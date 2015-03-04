require 'thor'
require 'pivotalpal/reports/projects'

module Pivotalpal
  class CLI < Thor
    include Thor::Actions

    desc "setup", "Setup PivotalPal"
    def setup
      key = ask("What is your PivotalTracker API key?")
      UserConfig.default('conf.yaml', { 'pt_api_key' => key })
      uconf = UserConfig.new('.pivotalpal')
      uconf.create('conf.yaml')
    end

    desc "my_projects", "List your projects"
    def my_projects
      Pivotalpal::Reports::Projects.new.mine
    end

    desc "all_projects", "List your projects"
    def all_projects
      Pivotalpal::Reports::Projects.new.all
    end



  end

end