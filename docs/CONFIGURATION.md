# Configuration Guide

[English](CONFIGURATION.en.md)

kansai_train_infoは設定をカスタマイズすることができます。

## 基本的な設定

```ruby
require 'kansai_train_info'

KansaiTrainInfo.configure do |config|
  config.timeout = 30          # タイムアウト時間（秒）
  config.max_retries = 5       # 最大リトライ回数
  config.retry_delay = 2       # リトライ間隔の基準時間（秒）
  config.user_agent = 'MyApp/1.0'  # User-Agentヘッダー
  config.base_url = 'https://transit.yahoo.co.jp'  # ベースURL
end
```

## 設定オプション

### timeout
- **型**: Integer
- **デフォルト**: 10
- **説明**: HTTP接続のタイムアウト時間（秒）

### max_retries
- **型**: Integer
- **デフォルト**: 3
- **説明**: 接続エラー時の最大リトライ回数

### retry_delay
- **型**: Integer
- **デフォルト**: 1
- **説明**: リトライ間隔の基準時間。実際の待機時間は指数バックオフで計算されます（1秒、2秒、4秒...）

### user_agent
- **型**: String
- **デフォルト**: "kansai_train_info/#{VERSION}"
- **説明**: HTTPリクエストのUser-Agentヘッダー

### base_url
- **型**: String
- **デフォルト**: 'https://transit.yahoo.co.jp'
- **説明**: APIのベースURL

## 設定のリセット

デフォルト設定に戻すには：

```ruby
KansaiTrainInfo.reset_configuration!
```

## カスタム路線の追加

デフォルトでサポートされていない路線を追加することができます：

```ruby
# JR神戸線を追加
KansaiTrainInfo.route_registry.register(
  'JR神戸線',
  area_index: 5,    # Yahoo!路線情報のエリアインデックス
  row_index: 1,     # テーブルの行インデックス
  detail_id: 264    # 詳細ページのID
)

# 追加した路線を使用
KansaiTrainInfo.get(['JR神戸線'])
```

### 路線情報の取得方法

1. [Yahoo!路線情報の関西エリア](https://transit.yahoo.co.jp/traininfo/area/6/)にアクセス
2. 追加したい路線を探す
3. ブラウザの開発者ツールで以下を確認：
   - `area_index`: 路線が含まれるdiv要素のインデックス
   - `row_index`: テーブル内の行番号
   - `detail_id`: 詳細ページURLに含まれるID

## 環境変数

以下の環境変数で設定することも可能です：

- `KANSAI_TRAIN_INFO_TIMEOUT`: タイムアウト時間
- `KANSAI_TRAIN_INFO_MAX_RETRIES`: 最大リトライ回数
- `KANSAI_TRAIN_INFO_USER_AGENT`: User-Agent

```bash
export KANSAI_TRAIN_INFO_TIMEOUT=30
export KANSAI_TRAIN_INFO_MAX_RETRIES=5
```