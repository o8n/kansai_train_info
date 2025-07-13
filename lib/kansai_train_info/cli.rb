module KansaiTrainInfo
  class CLI < Thor
    desc 'KansaiTrainInfo *routes', 'Get'
    def get(*routes)
      result = KansaiTrainInfo.get(routes)
      puts result if result
    end

    desc 'KansaiTrainInfo help', 'Help'
    def help
      KansaiTrainInfo.help
    end
  end
end
