# detailed.yazi

A compact, information-rich [Yazi](https://yazi-rs.github.io/) linemode displaying **file sizes**, **directory item counts**, **modification times**, and (on Unix-like systems) **owners** and **permissions**.

Directory counts are fetched asynchronously for visible entries, so you don't have to select a directory to see its count.

<img width="1905" height="1024" alt="detailed.yazi" src="https://github.com/user-attachments/assets/64fdabab-d75f-432d-bb7c-e0cf9c944e17" />

## Features

- Human-readable file sizes and **non-recursive** directory entry counts.
- Optional Nerd Font icon or text suffix **after** each count; it can also be disabled.
- Bounded asynchronous directory reads with configurable item and concurrency limits.
- A size/count field with configurable minimum width.
- Modification dates formatted as `Nov 21 15:32` (current year) or `Oct 12  2025` (other years), with fallbacks for unfamiliar timestamp representations.
- Username without the group suffix and Unix permissions on Linux, macOS, and WSL.
- Size/count and date on native Windows, with Unix-specific fields omitted.
- In-memory LRU cache with configurable capacity, time-to-live (TTL), and refresh when updated directory modification metadata is observed.

## Requirements

- [Yazi](https://yazi-rs.github.io/) with the plugin APIs `ya.async`, `ya.sync`, `fs.read_dir`, and `ui.render`. The plugin was developed against the **26.9.1** API documentation; compatibility across Yazi versions has not been fully verified in live sessions.
- A Nerd Font for the default item-count icon, **or** set `count_icon` to plain text or `""` to disable it.
- A Unix-like operating system **only if** you want owner and Unix permission fields. On native Windows, the plugin is designed to omit them.

> [!NOTE]
> Yazi documents `ya.async()` as experimental. Compatibility, especially on native Windows and across Yazi versions, should be verified in a running Yazi instance.

## Installation

Install the plugin from GitHub:

```sh
ya pkg add drekunia/detailed
```

### Enable the linemode

Add this to `~/.config/yazi/init.lua`:

```lua
require("detailed"):setup()
```

And this to `~/.config/yazi/yazi.toml`:

```toml
[mgr]
linemode = "detailed"
```

Restart Yazi to apply the changes.

## Configuration

All settings are optional. The following example shows the defaults:

```lua
require("detailed"):setup({
    max_items = 500,
    cache_ttl = 120,
    max_concurrent = 4,
    max_cache_entries = 1024,
    read_timeout = 30,
    count_icon = "\u{f0222}", -- Nerd Font: nf-md-file_multiple
    size_width = 7,
})
```

| Option              | Default       | Description                                                                                                                  |
| ------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `max_items`         | `500`         | Maximum exact directory count. Larger directories display `500+` (or the configured limit with `+`).                         |
| `cache_ttl`         | `120`         | Seconds before a cached count becomes eligible for refresh.                                                                  |
| `max_concurrent`    | `4`           | Maximum number of active directory-read tasks.                                                                               |
| `max_cache_entries` | `1024`        | Maximum number of cached directory entries. Completed entries are evicted by least-recent use.                               |
| `read_timeout`      | `30`          | Seconds before an unfinished read **may display** `?` instead of `...` on a subsequent render. Does **not** cancel the read. |
| `count_icon`        | `"\u{f0222}"` | Icon or text suffix placed after the count. Set to `""` for **no suffix**.                                                   |
| `size_width`        | `7`           | Minimum size/count field width in terminal cells; values longer than this are not truncated.                                 |

Numeric settings are validated and clamped to supported ranges. The effective `max_concurrent` does not exceed `max_cache_entries`.

**Without Nerd Fonts:**

```lua
require("detailed"):setup({
    count_icon = "items",
    size_width = 10,
})
```

**Without any icon or suffix:**

```lua
require("detailed"):setup({
    count_icon = "",
})
```

Example directory count displays:

| Setting                | 14 entries            | More than 500 entries   |
| ---------------------- | --------------------- | ----------------------- |
| Default                | `14` + Nerd Font icon | `500+` + Nerd Font icon |
| `count_icon = "items"` | `14 items`            | `500+ items`            |
| `count_icon = ""`      | `14`                  | `500+`                  |

## Behavior and limitations

- **Counts:** Includes immediate children (files and subdirectories), including hidden entries. Counts are not recursive, and they do not indicate disk usage.
- **Loading and errors:** New counts initially show `...`. Unreadable directories show `?`. After `read_timeout`, an unfinished read may also show `?` when its row next renders; the underlying operation continues.
- **Large directories:** Reads request at most `max_items + 1` entries. `500+` means **more than** 500 entries, not exactly 500.
- **Caching:** Counts are cached for the current Yazi session. Least-recently-used completed entries are evicted at the cache limit. In-flight entries are not evicted; if none can be evicted, new counts are deferred.
- **Refresh:** Counts become eligible for refresh after `cache_ttl` seconds or when changed directory modification metadata is observed. Refresh happens during subsequent row rendering, **not** through continuous polling. Metadata on remote or unusual filesystems may not update promptly.
- **Concurrency:** Running reads occupy their slots until completion, even after the display timeout. A filesystem operation that never finishes can delay further counts.
- **Dates:** The plugin prefers Yazi's numeric timestamps or Time objects and formats them as English abbreviated month, day, and time/year. If it cannot interpret a timestamp, it falls back to Yazi's built-in `self:mtime()` output, then to a raw timestamp string when available. It displays `-` only when no usable date can be retrieved. Fallback text may not match the preferred date style. Standard formatted dates use local time.
- **Platforms:** Owner and Unix permission fields appear only when `ya.target_family()` reports `unix`. Native Windows omits those fields; Windows support has not been fully tested in a live Yazi instance.
- **Alignment:** The size/count field is padded to a **minimum** display width, not truncated to a maximum. Wider counts, sizes, or usernames can shift subsequent content. If an icon appears misaligned, try a Nerd Font **Mono** variant.

## Development and testing

If your checkout includes the mock test suite, run it with Lua 5.4 or newer:

```sh
lua tests/test.lua
```

Tests written for earlier versions may require updates for the current caching, timeout, and date-fallback logic. Mock tests do not replace testing inside a running Yazi instance.

## License

MIT — see [LICENSE](LICENSE).
