module KansaiTrainInfo
  class CLI < Thor
    desc "KansaiTrainInfo *routes", "Get"
    def get(*routes)
      texts = KansaiTrainInfo.get(routes)
      texts.each do |text|
        print text
        print "\n"
      end
    end
  end
end
