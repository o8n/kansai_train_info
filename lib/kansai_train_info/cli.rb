module KansaiTrainInfo
  class CLI < Thor
    desc 'KansaiTrainInfo *routes', 'Get'
    def get(*routes)
      texts = KansaiTrainInfo.get(routes)
      texts.each do |text|
        print text
        print "\n"
      end
    end

    desc 'KansaiTrainInfo help', 'Help'
    def help
      KansaiTrainInfo.help
    end
  end
end
