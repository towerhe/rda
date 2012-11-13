module Rda
  module Helper
    def configured?(fname, conf)
      IO.readlines(fname).each do |l|
        if l.strip.start_with?(conf)
          $stderr.puts "INFO: #{conf} has already been set!"

          return true
        end
      end

      false
    end
  end
end
