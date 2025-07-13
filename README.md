# kansai_train_info

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/o8n/kansai_train_info/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/o8n/kansai_train_info/tree/master)

obtain train operation status in the Kansai region of Japan

## Usage


`gem install kansai_train_info`

or

gemfile: `gem 'kansai_train_info', '~> 0.2.0'`


``` sh
irb(main):001:0> require 'kansai_train_info'
=> true
irb(main):002:0> KansaiTrainInfo.get(['大阪環状線'])
大阪環状線は平常運転です
```

now support: `大阪環状線, 近鉄京都線, 阪急京都線, 御堂筋線, 烏丸線, 東西線`

## requirements

Ruby >= 3.0.0

## Development

### Type Checking

This gem uses RBS for type definitions and Steep for type checking.

```sh
# Run type checking
bundle exec steep check

# Or use rake task
bundle exec rake steep
```


<details><summary>Trouble Shoot</summary>

### can't read gem

```sh
irb(main):001:0> require 'kansai_train_info'
Traceback (most recent call last):
        6: from /Users/name/.rbenv/versions/2.7.1/bin/irb:23:in `<main>'
        5: from /Users/name/.rbenv/versions/2.7.1/bin/irb:23:in `load'
        4: from /Users/name/.rbenv/versions/2.7.1/lib/ruby/gems/2.7.0/gems/irb-1.2.3/exe/irb:11:in `<top (required)>'
        3: from (irb):1
        2: from /Users/name/.rbenv/versions/2.7.1/lib/ruby/2.7.0/rubygems/core_ext/kernel_require.rb:92:in `require'
        1: from /Users/name/.rbenv/versions/2.7.1/lib/ruby/2.7.0/rubygems/core_ext/kernel_require.rb:92:in `require'
LoadError (cannot load such file -- KansaiTrainInfo)
```

then excute

```txt
irb(main):002:0> $:
irb(main):003:0> $: << 'lib'
irb(main):012:0> require 'KansaiTrainInfo'
=> true
```

</details>
