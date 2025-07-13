# kansai_train_info

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/o8n/kansai_train_info/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/o8n/kansai_train_info/tree/master)
[![Gem Version](https://badge.fury.io/rb/kansai_train_info.svg)](https://badge.fury.io/rb/kansai_train_info)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Ruby Gem to obtain train operation status in the Kansai region of Japan.

[日本語版](README.md)

## Features

- 🚃 Real-time train operation information for major Kansai lines
- 🔄 Automatic retry functionality with exponential backoff
- ⚡ Fast HTTP communication and HTML parsing
- 🛡️ Comprehensive error handling
- 📝 Complete type definitions (RBS)
- 🎯 90%+ test coverage

## Installation

Install the gem:

```bash
gem install kansai_train_info
```

Or add to your Gemfile:

```ruby
gem 'kansai_train_info', '~> 0.2.0'
```

## Usage

### Ruby

```ruby
require 'kansai_train_info'

# Get information for a single line
KansaiTrainInfo.get(['大阪環状線'])
# => 大阪環状線は平常運転です (Osaka Loop Line is operating normally)

# Get information for multiple lines
KansaiTrainInfo.get(['大阪環状線', '御堂筋線'])
# => "大阪環状線は列車遅延があります。10分程度の遅れが発生しています。"

# Include detail URL
KansaiTrainInfo.get(['大阪環状線'], url: true)
# => "大阪環状線は列車遅延があります。https://transit.yahoo.co.jp/traininfo/detail/263/0/"

# Show available lines
KansaiTrainInfo.help
```

### CLI

```bash
# Single line
kansai_train_info get 大阪環状線

# Multiple lines
kansai_train_info get 大阪環状線 御堂筋線

# Include URL
kansai_train_info get 大阪環状線 --url

# Help
kansai_train_info help
```

## Supported Lines

- 大阪環状線 (Osaka Loop Line)
- 近鉄京都線 (Kintetsu Kyoto Line)
- 阪急京都線 (Hankyu Kyoto Line)
- 御堂筋線 (Midosuji Line)
- 烏丸線 (Karasuma Line)
- 東西線 (Tozai Line)

## Configuration

You can customize the configuration:

```ruby
KansaiTrainInfo.configure do |config|
  config.timeout = 30          # Timeout in seconds
  config.max_retries = 5       # Maximum number of retries
  config.retry_delay = 2       # Base retry delay in seconds
  config.user_agent = 'MyApp/1.0'
end
```

See [Configuration Guide](docs/CONFIGURATION.en.md) for details.

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

Check code style with Rubocop:

```sh
bundle exec rubocop
```

## Documentation

- [API Documentation](docs/API.en.md) - Detailed API reference ([日本語](docs/API.md))
- [Configuration Guide](docs/CONFIGURATION.en.md) - Configuration options ([日本語](docs/CONFIGURATION.md))
- [Contributing Guide](CONTRIBUTING.en.md) - How to contribute ([日本語](CONTRIBUTING.md))
- [Changelog](CHANGELOG.md) - Release history

## Error Handling

This gem provides the following custom errors:

- `KansaiTrainInfo::NetworkError` - Network-related errors
- `KansaiTrainInfo::TimeoutError` - Timeout errors
- `KansaiTrainInfo::ParseError` - HTML parsing errors
- `KansaiTrainInfo::InvalidRouteError` - Invalid route name errors

```ruby
begin
  KansaiTrainInfo.get(['Invalid Line'])
rescue KansaiTrainInfo::InvalidRouteError => e
  puts "Error: #{e.message}"
end
```

## Contributing

Bug reports and feature requests are welcome on [GitHub Issues](https://github.com/o8n/kansai_train_info/issues).

Pull requests are welcome! See the [Contributing Guide](CONTRIBUTING.en.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

- **o8n** - [GitHub](https://github.com/o8n)

## Acknowledgments

- Yahoo!路線情報 for providing the train operation data