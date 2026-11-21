local months = {
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
}

local function integer_option(value, default, minimum, maximum)
    if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
        return default
    end
    return math.max(minimum, math.min(maximum, math.floor(value)))
end

-- Format directly from file metadata when possible, but never hide a
-- usable date just because its representation is unfamiliar.
local function display_timestamp(year, month, day, hour, minute)
    if not (year and month and day and hour and minute and months[month]) then
        return nil
    end

    if year == tonumber(os.date("%Y")) then
        return string.format("%s %02d %02d:%02d", months[month], day, hour, minute)
    end

    return string.format("%s %02d  %04d", months[month], day, year)
end

local function format_mtime(linemode)
    local file = linemode._file
    local ok, mtime = pcall(function()
        if file.stat and file.stat.mtime ~= nil then
            return file.stat.mtime
        end
        return file.cha and file.cha.mtime
    end)
    if not ok then
        mtime = nil
    end

    local key

    -- If an unfamiliar metadata format is encountered, prefer Yazi's
    -- native output over hiding an otherwise valid modification time.
    local function fallback()
        local success, text = pcall(function()
            return linemode:mtime()
        end)
        if success and type(text) == "string" and text ~= "" then
            return text, key or text
        end

        if type(mtime) == "string" and mtime ~= "" then
            return mtime, key or mtime
        end

        return "-", key
    end

    if type(mtime) == "number" then
        key = tostring(mtime)
        local valid, date = pcall(os.date, "*t", math.floor(mtime))
        if valid and date then
            local result = display_timestamp(date.year, date.month, date.day, date.hour, date.min)
            if result then
                return result, key
            end
        end
    elseif type(mtime) == "string" then
        key = mtime
    elseif mtime ~= nil then
        -- Modern Yazi's Time objects support strftime-style formatting.
        local valid, iso = pcall(function()
            return mtime:format("%Y-%m-%d %H:%M:%S")
        end)

        if valid and type(iso) == "string" then
            key = iso
            local year, month, day, hour, minute = iso:match("^(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d)")
            if year then
                local result =
                    display_timestamp(tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(minute))
                if result then
                    return result, key
                end
            end
        end

        -- A future Time object might expose year and format() while
        -- changing its ISO output. Attempt direct formatting as well.
        local has_year, year = pcall(function()
            return tonumber(mtime.year)
        end)
        if has_year and year then
            local pattern = year == tonumber(os.date("%Y")) and "%b %d %H:%M" or "%b %d  %Y"
            local success, formatted = pcall(function()
                return mtime:format(pattern)
            end)
            if success and type(formatted) == "string" and formatted ~= "" then
                return formatted, key or formatted
            end
        end
    end

    return fallback()
end

local finish_count = ya.sync(function(state, path, request_id, count)
    local entry = state.counts[path]
    if not entry or not entry.loading or entry.request_id ~= request_id then
        return
    end

    entry.value = count
    entry.updated_at = os.time()
    entry.loading = false
    entry.request_id = nil
    state.active_reads = math.max(0, state.active_reads - 1)
    ui.render()
end)

local function evict_oldest(state)
    local oldest_path, oldest_seen
    for path, entry in pairs(state.counts) do
        -- In-flight reads must retain their entry until they finish.
        if not entry.loading and (oldest_seen == nil or entry.last_seen < oldest_seen) then
            oldest_path, oldest_seen = path, entry.last_seen
        end
    end

    if not oldest_path then
        return false
    end
    state.counts[oldest_path] = nil
    state.cache_size = state.cache_size - 1
    return true
end

return {
    setup = function(state, opts)
        opts = type(opts) == "table" and opts or {}

        local max_items = integer_option(opts.max_items, 500, 1, 1000000)
        local cache_ttl = integer_option(opts.cache_ttl, 120, 1, 86400)
        local max_cache_entries = integer_option(opts.max_cache_entries, 1024, 16, 8192)
        local max_concurrent = math.min(integer_option(opts.max_concurrent, 4, 1, 32), max_cache_entries)
        local read_timeout = integer_option(opts.read_timeout, 30, 1, 300)
        local size_width = integer_option(opts.size_width, 7, 0, 40)
        local count_icon = type(opts.count_icon) == "string" and opts.count_icon or "\u{f0222}"
        local icon_suffix = count_icon ~= "" and (" " .. count_icon) or ""

        state.counts = {}
        state.cache_size = 0
        state.active_reads = 0
        state.lru_tick = 0
        state.request_seq = 0

        function Linemode:detailed()
            local file = self._file
            local time, mtime_key = format_mtime(self)
            local size

            if file.cha and file.cha.is_dir then
                local url = file.url
                local path = tostring(url)
                local now = os.time()
                local entry = state.counts[path]

                state.lru_tick = state.lru_tick + 1

                if not entry then
                    if state.cache_size >= max_cache_entries then
                        evict_oldest(state)
                    end

                    -- If every cached entry has an in-flight read, wait for one
                    -- to complete rather than exceeding the cache limit.
                    if state.cache_size < max_cache_entries then
                        entry = {
                            value = nil,
                            updated_at = 0,
                            loading = false,
                            started_at = 0,
                            request_id = nil,
                            mtime_key = nil,
                            last_seen = 0,
                        }
                        state.counts[path] = entry
                        state.cache_size = state.cache_size + 1
                    end
                end

                if entry then
                    entry.last_seen = state.lru_tick
                    local expired = entry.updated_at == 0 or now - entry.updated_at >= cache_ttl
                    local changed = mtime_key ~= nil and mtime_key ~= entry.mtime_key

                    if not entry.loading and state.active_reads < max_concurrent and (expired or changed) then
                        state.request_seq = state.request_seq + 1
                        local request_id = state.request_seq

                        entry.loading = true
                        entry.started_at = now
                        entry.request_id = request_id
                        entry.mtime_key = mtime_key
                        state.active_reads = state.active_reads + 1

                        local scheduled = pcall(ya.async, function()
                            local ok, count = pcall(function()
                                local files = fs.read_dir(url, { limit = max_items + 1 })
                                return files and #files or -1
                            end)
                            finish_count(path, request_id, ok and count or -1)
                        end)

                        if not scheduled then
                            -- The task never started: release its reserved slot.
                            entry.loading = false
                            entry.request_id = nil
                            entry.value = entry.value or -1
                            entry.updated_at = now
                            state.active_reads = state.active_reads - 1
                        end
                    end

                    local timed_out = entry.loading and now - entry.started_at >= read_timeout
                    local count = entry.value

                    if count == nil then
                        size = timed_out and "?" or "..."
                    elseif count < 0 then
                        size = "?"
                    elseif count > max_items then
                        size = max_items .. "+" .. icon_suffix
                    else
                        size = count .. icon_suffix
                    end
                else
                    -- All cache entries are busy. Try again on the next render.
                    size = "..."
                end
            else
                local bytes = file:size()
                size = bytes and ya.readable_size(bytes) or ""
            end

            local width = ui.Line(size):width()
            size = string.rep(" ", math.max(0, size_width - width)) .. size

            local parts = { size, time }
            if ya.target_family() == "unix" then
                local owner = (self:owner() or ""):match("^[^:]+")
                local permissions = self:permissions()
                if owner and owner ~= "" then
                    table.insert(parts, owner)
                end
                if permissions and permissions ~= "" then
                    table.insert(parts, permissions)
                end
            end

            return table.concat(parts, " ")
        end
    end,
}
