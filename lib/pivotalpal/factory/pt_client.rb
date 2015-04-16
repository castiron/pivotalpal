require 'tracker_api'
require 'pivotalpal/config/user'

module Pivotalpal
  module Factory
    class PTClient

      def self.get
        config = Pivotalpal::Config::User.instance.all
        client = TrackerApi::Client.new(token: config['pt_api_key'])
        client
      end

    end
  end
end
