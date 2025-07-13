# Configuration Guide

[日本語](CONFIGURATION.md)

kansai_train_info can be customized with various configuration options.

## Basic Configuration

```ruby
require 'kansai_train_info'

KansaiTrainInfo.configure do |config|
  config.timeout = 30          # Timeout in seconds
  config.max_retries = 5       # Maximum number of retries
  config.retry_delay = 2       # Base retry delay in seconds
  config.user_agent = 'MyApp/1.0'  # User-Agent header
  config.base_url = 'https://transit.yahoo.co.jp'  # Base URL
end
```

## Configuration Options

### timeout
- **Type**: Integer
- **Default**: 10
- **Description**: HTTP connection timeout in seconds

### max_retries
- **Type**: Integer
- **Default**: 3
- **Description**: Maximum number of retries on connection error

### retry_delay
- **Type**: Integer
- **Default**: 1
- **Description**: Base retry delay. Actual wait time is calculated with exponential backoff (1s, 2s, 4s...)

### user_agent
- **Type**: String
- **Default**: "kansai_train_info/#{VERSION}"
- **Description**: User-Agent header for HTTP requests

### base_url
- **Type**: String
- **Default**: 'https://transit.yahoo.co.jp'
- **Description**: Base URL for the API

## Resetting Configuration

To reset to default configuration:

```ruby
KansaiTrainInfo.reset_configuration!
```

## Adding Custom Lines

You can add lines that are not supported by default:

```ruby
# Add JR Kobe Line
KansaiTrainInfo.route_registry.register(
  'JR神戸線',
  area_index: 5,    # Area index from Yahoo! Transit Info
  row_index: 1,     # Row index in the table
  detail_id: 264    # Detail page ID
)

# Use the added line
KansaiTrainInfo.get(['JR神戸線'])
```

### How to Get Line Information

1. Access [Yahoo! Transit Info Kansai Area](https://transit.yahoo.co.jp/traininfo/area/6/)
2. Find the line you want to add
3. Use browser developer tools to check:
   - `area_index`: Index of the div element containing the line
   - `row_index`: Row number in the table
   - `detail_id`: ID included in the detail page URL

## Environment Variables

You can also configure using environment variables:

- `KANSAI_TRAIN_INFO_TIMEOUT`: Timeout duration
- `KANSAI_TRAIN_INFO_MAX_RETRIES`: Maximum retries
- `KANSAI_TRAIN_INFO_USER_AGENT`: User-Agent

```bash
export KANSAI_TRAIN_INFO_TIMEOUT=30
export KANSAI_TRAIN_INFO_MAX_RETRIES=5
```