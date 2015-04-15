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

    desc "all_backlogs", "List number of stories in backlogs per member"
    def all_backlogs
      proj = ask("Which project's backlog count would you like to see?")
      Pivotalpal::Reports::Projects.new.backlog(proj)
    end

  end

end
