require 'tracker_api'
require 'command_line_reporter'
require 'PP'
require 'pivotalpal/factory/pt_client'

module Pivotalpal
  module Reports
    class Projects

      include CommandLineReporter

      def init_client()
        @client = Pivotalpal::Factory::PTClient::get
        @projects = @client.projects.sort_by {|v| v.name}
      end

      def color_columns(state)
        return state.length == 0 ? column(state.length, :color => 'white') : column(state.length, :color => 'red')
      end


      def all
        init_client()
        table(:border => true) do

          row do
            column('PROJECT', :width => 40, :color => 'white')
            column('OWNER', :width => 8, :color => 'white')
            column('CURRENT', :width => 8, :color => 'white')
            column('BACKLOG', :width => 8, :color => 'white')
            column('ICEBOX', :width => 8, :color => 'white')
            column('ITER. LENGTH', :width => 8, :color => 'white')
          end

          @projects.each do |project|
            owners = project.memberships.select { |m| m.role == 'owner' }.map { |m| m.person.initials }.join(', ')
            current = project.stories(:filter => "state:planned")
            backlogs = project.stories(:filter => 'state:unstarted')
            iceboxes = project.stories(:filter => 'state:unscheduled')
            row do
              column(project.name, :color => 'cyan')
              column(owners, :color => 'yellow')
              color_columns(current)
              color_columns(backlogs)
              color_columns(iceboxes)
              column(project.iteration_length, :color => 'red')
            end
          end
        end

      end

      def get_project(proj)
        init_client()
        @projects.each do |project|
          if project.name.downcase == proj.downcase
            project_query = project
            return project_query
          end
        end
        header(:title => "That projjy ain't found! (Run 'list_projects' to see proper project titles)", :color => 'red')
        exit
      end

      def project_single(proj)
        project = get_project(proj)

        backlog_total = 0
        current_total = 0
        icebox_total = 0
        owners = project.memberships.select { |m| m.role == 'owner' }.map { |m| m.person.initials }.join(', ')
        members = project.memberships.select { |m| m.role == 'member' || m.role == 'owner' }.map { |m| m.person.initials }.join(',')

        header(:title => project.name,
               :align => 'center',
               :color => 'red',
               :bold => true,
               :rule => true,
               :width => 67)

        header(:title => "OWNERS: #{owners}",
               :align => 'center',
               :color => 'magenta',
               :width => 67)

        table(:border => true) do

          row do
            column('MEMBER', :width => 10, :color => 'white')
            column('# of CURRENT', :width => 15, :color => 'white')
            column('# of BACKLOGGED', :width => 15, :color => 'white')
            column('# of ICEBOXED', :width => 15, :color => 'white')
          end

          members.split(",").each do |member|
            current =  project.stories(:filter => "state:planned owner:#{member.upcase}")
            backlog =  project.stories(:filter => "state:unstarted owner:#{member.upcase}")
            icebox =  project.stories(:filter =>  "state:unscheduled owner:#{member.upcase}")

            row do
              column(member.upcase, :color => 'yellow')
              color_columns(current)
              color_columns(backlog)
              color_columns(icebox)
            end

            current_total += current.length
            backlog_total += backlog.length
            icebox_total += icebox.length
          end

          row do
            column('TOTAL', :color => 'magenta')
            column(current_total, :color => 'magenta')
            column(backlog_total, :color => 'magenta')
            column(icebox_total,  :color => 'magenta')
          end

        end
    end

    def list_projects
      output = []
      init_client()
      @projects.each do |project|
        output.push(project.name)
      end
      puts output.join(', ')
    end

    def mine
      init_client()
      table(:border => true) do
        row do
          column('PROJECT', :width => 40)
          column('ROLE', :width => 10)
        end
        projects = @client.me.projects.sort_by {|v| v.project_name}
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
