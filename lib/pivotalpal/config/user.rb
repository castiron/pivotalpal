require 'user_config'
require 'singleton'

module Pivotalpal
  module Config
    class User
      include Singleton

      def initialize
        uconf = UserConfig.new(".pivotalpal")
        @config_storage = uconf["conf.yaml"]
      end

      def all
        @config_storage
      end

    end
  end
end