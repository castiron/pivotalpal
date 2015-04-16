require 'tracker_api'
require 'command_line_reporter'
require 'PP'
require 'pivotalpal/factory/pt_client'
require 'pivotalpal/repository/story'

module Pivotalpal
  module Reports
    class Projects

      include CommandLineReporter

      def all
        table(:border => true) do
          row do
            column('PROJECT', :width => 40)
            column('OWNER', :width => 10)
            column('BACKLOG', :width => 8)
            column('ICEBOX', :width => 8)
            column('ITER. LENGTH', :width => 8)
          end
          client = Pivotalpal::Factory::PTClient::get
          projects = client.projects.sort_by {|v| v.name}
          projects.each do |project|
            owners = project.memberships.select { |m| m.role == 'owner' }.map { |m| m.person.initials }.join(', ')
            row do
              column(project.name)
              column(owners)
              column(project.stories(:filter => 'state:unstarted').length)
              column(project.stories(:filter => 'state:unscheduled').length)
              column(project.iteration_length)
            end
          end
        end

      end

      def single_backlog(proj)
        client = Pivotalpal::Factory::PTClient::get
        projects = client.projects.sort_by{|v| v.name}
        projects.each do |project|
          if project.name.downcase == proj.downcase
            story_repository = Pivotalpal::Repository::StoryRepository.new(:project => project)
            header(:title => project.name,
                   :align => 'center',
                   :color => 'red',
                   :rule => true,
                   :bold => true,
                   :width => 40)

            table(:border => true) do
              row do
                column('MEMBER', :width => 10,
                                 :color => 'blue')
                column('# of BACKLOGS', :width => 15,
                                        :color => 'blue')
              end

              members = project.memberships.select { |m| m.role == 'member' || m.role == 'owner' }.map { |m| m.person.initials }.join(',')
              members.split(",").each do |member|
                row do
                  column(member.upcase, :color => 'red')
                  column(story_repository.get_by_filters(['state:unstarted', "owner:#{member.upcase}"]).length, :color => 'green')
                end
              end
            end
          end
        end
    end

    # def all_backlogs
    #   client = Pivotalpal::Factory::PTClient::get
    #   projects = client.projects.sort_by

    def get_members
      final_members = []
      client = Pivotalpal::Factory::PTClient::get
      projects = client.projects.sort_by{|v| v.name}
      projects.each do |project|
        members = project.memberships.select { |m| m.role == 'member' }.map { |m| m.person.initials }.join(',')
        members.split(",").each do |member|
          if not final_members.include? member
            final_members.push(member)
          end
        end
      end
      puts final_members
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
