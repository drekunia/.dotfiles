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

local update_count = ya.sync(function(state, path, count)
	state.counts[path] = count
	ui.render()
end)

return {
	setup = function(state)
		state.counts = {}

		function Linemode:detailed()
			local time = self:mtime() or "-"

			time = time:gsub("^(%d%d)/(%d%d)", function(month, day)
				return months[tonumber(month)] .. " " .. day
			end)

			time = time:gsub("^(%a%a%a %d%d) (%d%d%d%d)$", "%1  %2")

			local size

			if self._file.cha.is_dir then
				local url = self._file.url
				local path = tostring(url)

				if state.counts[path] == nil then
					state.counts[path] = false

					ya.async(function()
						local files = fs.read_dir(url, {})
						update_count(path, files and #files or -1)
					end)
				end

				local count = state.counts[path]
				size = type(count) == "number" and (count >= 0 and count .. " \u{f0222}" or "?") or "..."
			else
				local bytes = self._file:size()
				size = bytes and ya.readable_size(bytes) or ""
			end

			local owner = (self:owner() or "-"):match("^[^:]+") or "-"

			return string.format("%s %s %s %s", size, time, owner, self:permissions() or "-")
		end
	end,
}
