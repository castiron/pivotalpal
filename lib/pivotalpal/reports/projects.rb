require 'tracker_api'
require 'command_line_reporter'
require 'PP'
require 'pivotalpal/factory/pt_client'

module Pivotalpal
  module Reports
    class Projects

      include CommandLineReporter

      def all
        table(:border => true) do
          row do
            column('PROJECT', :width => 40, :color => 'white')
            column('OWNER', :width => 8, :color => 'white')
            column('CURRENT', :width => 8, :color => 'white')
            column('BACKLOG', :width => 8, :color => 'white')
            column('ICEBOX', :width => 8, :color => 'white')
            column('ITER. LENGTH', :width => 8, :color => 'white')
          end
          client = Pivotalpal::Factory::PTClient::get
          projects = client.projects.sort_by {|v| v.name}
          projects.each do |project|
            owners = project.memberships.select { |m| m.role == 'owner' }.map { |m| m.person.initials }.join(', ')
            current = project.stories(:filter => "state:planned")
            backlogs = project.stories(:filter => 'state:unstarted')
            iceboxes = project.stories(:filter => 'state:unscheduled')
            row do
              column(project.name, :color => 'cyan')
              column(owners, :color => 'yellow')
              if current.length == 0
                column(current.length, :color => 'white')
              else
                column(current.length, :color => 'red')
              end
              if backlogs.length == 0 # Easy to weed out 0s from substantial tallies
                column(backlogs.length, :color => 'white')
              else
                column(backlogs.length, :color => 'cyan')
              end
              if iceboxes.length == 0
                column(iceboxes.length, :color => 'white')
              else
                column(iceboxes.length, :color => 'yellow')
              end
              column(project.iteration_length, :color => 'red')
            end
          end
        end

      end

      def get_project(proj)
        client = Pivotalpal::Factory::PTClient::get
        projects = client.projects.sort_by {|v| v.name}
        projects.each do |project|
          if project.name.downcase == proj.downcase
            return project
          end
        end
        false
      end

      def backlog_single(proj)
        if get_project(proj)
          @project_query = get_project(proj)
        else
          header(:title => "That projjy ain't found! (Run 'list_projects' to see proper project titles)", :color => 'red')
        end

        if defined? @project_query
          backlog_total = 0
          header(:title => @project_query.name,
                 :align => 'center',
                 :color => 'red',
                 :bold => true,
                 :rule => true,
                 :width => 40)

          table(:border => true) do
            row do
              column('MEMBER', :width => 10, :color => 'white')
              column('# of BACKLOGS', :width => 15, :color => 'white')
            end

            members = @project_query.memberships.select { |m| m.role == 'member' || m.role == 'owner' }.map { |m| m.person.initials }.join(',')
            members.split(",").each do |member|
              backlog_count = @project_query.stories(:filter => "state:unstarted owner:#{member.upcase}").length
              if backlog_count == 0
                row do
                  column(member.upcase, :color => 'yellow')
                  column(backlog_count, :color => 'white')
                end

              else
                row do
                  column(member.upcase, :color => 'yellow')
                  column(backlog_count, :color => 'cyan')
                end
              end
              backlog_total += backlog_count
            end
            row do
              column('TOTAL', :color => 'red')
              column(backlog_total, :color => 'red')
            end
          end
        end

    end

    def backlog_all
      client = Pivotalpal::Factory::PTClient::get
      projects = client.projects.sort_by {|v| v.name}
      projects.each do |project|
        backlog_single(project.name)
      end
    end

    def list_projects
      output = []
      client = Pivotalpal::Factory::PTClient::get
      projects = client.projects.sort_by{|v| v.name}
      projects.each do |project|
        output.push(project.name)
      end
      puts output.join(', ')
    end


      def mine
        table(:border => true) do
          row do
            column('PROJECT', :width => 40)
            column('ROLE', :width => 10)
          end
          client = Pivotalpal::Factory::PTClient::get
          projects = client.me.projects.sort_by {|v| v.project_name}
          owner_projects = projects.select { |p| p.role == 'owner' }
          owner_projects.each do |project|
            row do
              column(project.project_name)
              column(project.role)
            end
          end
        end
      end

    end
  end
end
