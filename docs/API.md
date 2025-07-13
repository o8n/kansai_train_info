# API Documentation

[English](API.en.md)

## KansaiTrainInfo

### メソッド

#### `KansaiTrainInfo.get(route_array, url: false)`

指定された路線の運行情報を取得します。

**パラメータ:**
- `route_array` (Array<String>): 取得したい路線名の配列
- `url` (Boolean): 詳細URLを含めるかどうか（デフォルト: false）

**戻り値:**
- `String`: 運行情報のメッセージ（複数路線の場合はカンマ区切り）
- `nil`: 正常運転の場合

**例:**
```ruby
# 単一路線
KansaiTrainInfo.get(['大阪環状線'])
# => "大阪環状線は平常運転です"（標準出力に出力され、nilを返す）

# 複数路線
KansaiTrainInfo.get(['大阪環状線', '御堂筋線'])
# => "大阪環状線は列車遅延があります。10分程度の遅れが発生しています。"

# URLを含める
KansaiTrainInfo.get(['大阪環状線'], url: true)
# => "大阪環状線は列車遅延があります。10分程度の遅れが発生しています。https://transit.yahoo.co.jp/traininfo/detail/263/0/"
```

#### `KansaiTrainInfo.help`

利用可能な路線を表示します。

**例:**
```ruby
KansaiTrainInfo.help
# => 利用可能な路線：
# => 大阪環状線、近鉄京都線、阪急京都線, 御堂筋線, 烏丸線, 東西線
```

### エラーハンドリング

以下のカスタムエラークラスが定義されています：

- `KansaiTrainInfo::Error` - 基底エラークラス
- `KansaiTrainInfo::NetworkError` - ネットワーク関連のエラー
- `KansaiTrainInfo::TimeoutError` - タイムアウトエラー
- `KansaiTrainInfo::ParseError` - HTML解析エラー
- `KansaiTrainInfo::InvalidRouteError` - 無効な路線名エラー

**例:**
```ruby
begin
  KansaiTrainInfo.get(['存在しない路線'])
rescue KansaiTrainInfo::InvalidRouteError => e
  puts "エラー: #{e.message}"
end
```

## CLI

### コマンド

#### `kansai_train_info get [ROUTES...]`

指定された路線の運行情報を取得します。

**オプション:**
- `-u`, `--url`: 詳細URLを含める

**例:**
```bash
# 単一路線
kansai_train_info get 大阪環状線

# 複数路線
kansai_train_info get 大阪環状線 御堂筋線

# URLを含める
kansai_train_info get 大阪環状線 --url
```

#### `kansai_train_info help`

利用可能な路線とコマンドのヘルプを表示します。

```bash
kansai_train_info help
```

## サポートされている路線

- 大阪環状線
- 近鉄京都線
- 阪急京都線
- 御堂筋線
- 烏丸線
- 東西線