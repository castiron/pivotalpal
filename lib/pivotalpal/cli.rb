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

    desc "single_backlog", "Shows a report of total backlogs per member for a single project"
    def single_backlogs
      proj = ask("Which project's backlog count would you like to see?")
      Pivotalpal::Reports::Projects.new.single_backlog(proj)
    end

    desc "list_projects", "List all projects"
    def list_projects
      Pivotalpal::Reports::Projects.new.list_projects
    end

    desc "get_members", "Lists all members of all projects"
    def get_members
      Pivotalpal::Reports::Projects.new.get_members
    end

  end

end
