# API Documentation

[日本語](API.md)

## KansaiTrainInfo

### Methods

#### `KansaiTrainInfo.get(route_array, url: false)`

Get train operation information for specified lines.

**Parameters:**
- `route_array` (Array<String>): Array of line names to query
- `url` (Boolean): Whether to include detail URL (default: false)

**Returns:**
- `String`: Operation status message (comma-separated for multiple lines)
- `nil`: When operating normally

**Examples:**
```ruby
# Single line
KansaiTrainInfo.get(['大阪環状線'])
# => "大阪環状線は平常運転です" (outputs to stdout and returns nil)

# Multiple lines
KansaiTrainInfo.get(['大阪環状線', '御堂筋線'])
# => "大阪環状線は列車遅延があります。10分程度の遅れが発生しています。"

# Include URL
KansaiTrainInfo.get(['大阪環状線'], url: true)
# => "大阪環状線は列車遅延があります。10分程度の遅れが発生しています。https://transit.yahoo.co.jp/traininfo/detail/263/0/"
```

#### `KansaiTrainInfo.help`

Display available lines.

**Example:**
```ruby
KansaiTrainInfo.help
# => 利用可能な路線：
# => 大阪環状線、近鉄京都線、阪急京都線, 御堂筋線, 烏丸線, 東西線
```

### Error Handling

The following custom error classes are defined:

- `KansaiTrainInfo::Error` - Base error class
- `KansaiTrainInfo::NetworkError` - Network-related errors
- `KansaiTrainInfo::TimeoutError` - Timeout errors
- `KansaiTrainInfo::ParseError` - HTML parsing errors
- `KansaiTrainInfo::InvalidRouteError` - Invalid route name errors

**Example:**
```ruby
begin
  KansaiTrainInfo.get(['Non-existent Line'])
rescue KansaiTrainInfo::InvalidRouteError => e
  puts "Error: #{e.message}"
end
```

## CLI

### Commands

#### `kansai_train_info get [ROUTES...]`

Get train operation information for specified lines.

**Options:**
- `-u`, `--url`: Include detail URL

**Examples:**
```bash
# Single line
kansai_train_info get 大阪環状線

# Multiple lines
kansai_train_info get 大阪環状線 御堂筋線

# Include URL
kansai_train_info get 大阪環状線 --url
```

#### `kansai_train_info help`

Display available lines and command help.

```bash
kansai_train_info help
```

## Supported Lines

- 大阪環状線 (Osaka Loop Line)
- 近鉄京都線 (Kintetsu Kyoto Line)
- 阪急京都線 (Hankyu Kyoto Line)
- 御堂筋線 (Midosuji Line)
- 烏丸線 (Karasuma Line)
- 東西線 (Tozai Line)