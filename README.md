# KansaiTrainInfo
WIP

![./kansai.gif](./kansai.gif)

## Usage

``` sh
irb
irb(main):001:0> require 'KansaiTrainInfo'
=> true
irb(main):002:0> KansaiTrainInfo.get(['大阪環状線'])
大阪環状線は平常運転です
```

now support: 大阪環状線, 近鉄京都線, 阪急京都線, 御堂筋線, 烏丸線, 東西線

### troubleshoot

When you catch

```sh
irb(main):001:0> require 'KansaiTrainInfo'
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
