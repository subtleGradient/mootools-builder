#!/usr/bin/env ruby
module MooTools
  class Getter
    
    GIT           = ENV['TM_GIT'] || '/usr/local/bin/git'
    # GIT_URL     = ENV['MT_GIT_URL'      ] || 'git@github.com:mootools/mootools-core.git'
    GIT_URL       = ENV['MT_GIT_URL'      ] || 'git://github.com/mootools/mootools-core.git'
    CHECKOUT_PATH = ENV['MT_CHECKOUT_PATH'] || File.expand_path('~/git/mootools-core')
    DOWNLOAD_PATH = ENV['MT_DOWNLOAD_PATH'] || File.expand_path('~/httpdocs/downloads')
    MASTER_NAME   = ENV['MT_MASTER_NAME'  ] || 'mootools-core-edge.js'
    BUILD_PATH    = ENV['MT_BUILD_PATH'   ] || DOWNLOAD_PATH + '/' + MASTER_NAME
    
    class << self
      
      def update!
        get!
        build!
        cache!
        self
      end
      
      def get!
        if File.exists? CHECKOUT_PATH + '/.git'
          `cd '#{CHECKOUT_PATH}'; '#{GIT}' pull origin master`
        else
          `'#{GIT}' clone '#{GIT_URL}' '#{CHECKOUT_PATH}'`
        end
      end
      
      def build!
        raise "'#{CHECKOUT_PATH}' doesn't exist" unless File.exists?(CHECKOUT_PATH)
        require "#{CHECKOUT_PATH}/build"
        
        @builder = MooTools::Build.new
      end
      
      def cache!
        FileUtils.mkdir_p File.dirname(BUILD_PATH)
        @builder.save BUILD_PATH
      end
      
      private
      def `(cmd)
        Kernel.`(cmd) #`
      end
      
    end
  end
end

if __FILE__ == $0
  
  m = MooTools::Getter.update!
  
end
