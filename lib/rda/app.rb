module Rda
  class App < Thor
    desc "Restart", "Restart rails application"
    def restart
      tmp_path = ::Rails.root.to_s + "/tmp"
      FileUtils.mkdir_p tmp_path unless Dir.exists?(tmp_path)

      FileUtils.touch tmp_path + "/restart.txt"
    end
  end
end
