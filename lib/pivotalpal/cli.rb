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

    desc "project_single", "Single project backlog by user"
    def project_single
      proj = ask("Which project's backlog count would you like to see?")
      Pivotalpal::Reports::Projects.new.project_single(proj)
    end

    # To ease single backlog lookup input
    desc "list_projects", "List all projects"
    def list_projects
      Pivotalpal::Reports::Projects.new.list_projects
    end

    desc '--version', 'Ouputs version information'
    def version
      puts "#{Pivotalpal::VERSION}"
    end
    map '-v' => :version, '--version' => :version

    # desc "backlog_all", "All project backlogs by user"
    # def backlog_all
    #     Pivotalpal::Reports::Projects.new.backlog_all
    # end

  end

end
