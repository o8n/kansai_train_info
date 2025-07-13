# frozen_string_literal: true

require 'kansai_train_info'

# カスタム路線を追加する例
KansaiTrainInfo.route_registry.register(
  'JR神戸線',
  area_index: 5,
  row_index: 1,
  detail_id: 264
)

# 追加した路線も含めて取得
routes = ['大阪環状線', 'JR神戸線']
puts KansaiTrainInfo.get(routes)

# 利用可能な全路線を表示
KansaiTrainInfo.help