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
              column('')
              column('')
              column(project.iteration_length)
            end
          end
        end

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