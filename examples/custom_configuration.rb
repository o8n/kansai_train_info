# frozen_string_literal: true

require 'kansai_train_info'

# カスタム設定の例
KansaiTrainInfo.configure do |config|
  config.timeout = 30          # タイムアウトを30秒に設定
  config.max_retries = 5       # 最大5回リトライ
  config.retry_delay = 2       # リトライ間隔を2秒から開始
  config.user_agent = 'MyApp/1.0'
end

# 通常通り使用
puts KansaiTrainInfo.get(%w[大阪環状線 御堂筋線])

# 設定をデフォルトに戻す
KansaiTrainInfo.reset_configuration!
