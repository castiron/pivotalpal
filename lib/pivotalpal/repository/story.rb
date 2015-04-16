require 'tracker_api'
require 'pivotalpal/config/user'

module Pivotalpal
  module Repository
    class StoryRepository

      def initialize(args)
        @project = args[:project]
      end

      def get_by_filter(filter)
        @project.stories(:filter => filter)
      end

      def get_by_filters(filters)
        results = []
        filters.each do |f|
          results.push(get_by_filter f)
        end
        results[0] & results[1]
      end

    end
  end
end

# # Let me get a story repo for the 'carnegie' projjy
# story_repository = Pivotalpal::Repository::StoryRepository.new({:project => 'cargnegie'})
#
#
# # Let me get the stories filterd by yahoo whatever:
# member = get_my_member
# story_repositoy.get_by_filters ['state:unstarted', "owner:#{member.upcase}"]
