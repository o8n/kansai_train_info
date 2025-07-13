# kansai_train_info

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/o8n/kansai_train_info/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/o8n/kansai_train_info/tree/master)
[![CI](https://github.com/o8n/kansai_train_info/actions/workflows/ci.yml/badge.svg)](https://github.com/o8n/kansai_train_info/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/o8n/kansai_train_info/branch/master/graph/badge.svg)](https://codecov.io/gh/o8n/kansai_train_info)
[![Gem Version](https://badge.fury.io/rb/kansai_train_info.svg)](https://badge.fury.io/rb/kansai_train_info)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

関西地方の鉄道運行情報を取得するRuby Gemです。

[English](README.en.md)

## Features

- 🚃 関西主要路線の運行情報をリアルタイム取得
- 🔄 自動リトライ機能（指数バックオフ付き）
- ⚡ 高速なHTTP通信とHTML解析
- 🛡️ 包括的なエラーハンドリング
- 📝 完全な型定義（RBS）
- 🎯 90%以上のテストカバレッジ

## Installation

Gemをインストール:

```bash
gem install kansai_train_info
```

または、Gemfileに追加:

```ruby
gem 'kansai_train_info', '~> 0.2.0'
```

## Usage

### Ruby

```ruby
require 'kansai_train_info'

# 単一路線の情報を取得
KansaiTrainInfo.get(['大阪環状線'])
# => 大阪環状線は平常運転です

# 複数路線の情報を取得
KansaiTrainInfo.get(['大阪環状線', '御堂筋線'])
# => "大阪環状線は列車遅延があります。10分程度の遅れが発生しています。"

# 詳細URLを含める
KansaiTrainInfo.get(['大阪環状線'], url: true)
# => "大阪環状線は列車遅延があります。https://transit.yahoo.co.jp/traininfo/detail/263/0/"

# 利用可能な路線を表示
KansaiTrainInfo.help
```

### CLI

```bash
# 単一路線
kansai_train_info get 大阪環状線

# 複数路線
kansai_train_info get 大阪環状線 御堂筋線

# URLを含める
kansai_train_info get 大阪環状線 --url

# ヘルプ
kansai_train_info help
```

## Supported Lines

- 大阪環状線
- 近鉄京都線
- 阪急京都線
- 御堂筋線
- 烏丸線
- 東西線

## Configuration

カスタム設定が可能です：

```ruby
KansaiTrainInfo.configure do |config|
  config.timeout = 30          # タイムアウト時間（秒）
  config.max_retries = 5       # 最大リトライ回数
  config.retry_delay = 2       # リトライ間隔の基準時間（秒）
  config.user_agent = 'MyApp/1.0'
end
```

詳細は[Configuration Guide](docs/CONFIGURATION.md)を参照してください。

## Requirements

- Ruby >= 3.0.0

## Development

### Testing

Run tests with coverage report:

```sh
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/kansai_train_info/client_spec.rb

# View coverage report
open coverage/index.html
```

The project maintains a minimum test coverage of 90%.

### Type Checking

This gem uses RBS for type definitions and Steep for type checking.

```sh
# Run type checking
bundle exec steep check

# Or use rake task
bundle exec rake steep
```


### Linting

Rubocopでコードスタイルをチェック:

```sh
bundle exec rubocop
```

## Documentation

- [API Documentation](docs/API.md) - 詳細なAPIリファレンス ([English](docs/API.en.md))
- [Configuration Guide](docs/CONFIGURATION.md) - 設定オプションの詳細 ([English](docs/CONFIGURATION.en.md))
- [Contributing Guide](CONTRIBUTING.md) - 貢献方法 ([English](CONTRIBUTING.en.md))
- [Changelog](CHANGELOG.md) - 変更履歴

## Error Handling

このgemは以下のカスタムエラーを提供します：

- `KansaiTrainInfo::NetworkError` - ネットワーク関連のエラー
- `KansaiTrainInfo::TimeoutError` - タイムアウトエラー
- `KansaiTrainInfo::ParseError` - HTML解析エラー
- `KansaiTrainInfo::InvalidRouteError` - 無効な路線名エラー

```ruby
begin
  KansaiTrainInfo.get(['存在しない路線'])
rescue KansaiTrainInfo::InvalidRouteError => e
  puts "エラー: #{e.message}"
end
```

## Contributing

バグ報告や機能リクエストは[GitHub Issues](https://github.com/o8n/kansai_train_info/issues)でお願いします。

プルリクエストも歓迎です！詳細は[Contributing Guide](CONTRIBUTING.md)を参照してください。

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

- **o8n** - [GitHub](https://github.com/o8n)

## Acknowledgments

- Yahoo!路線情報 for providing the train operation data
