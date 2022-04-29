#!/usr/bin/env ruby
require 'xcodeproj'

def self.get_config_obj(project_filepath, target_name, project_configuration)
    project_directory=File.dirname project_filepath
    unless File.directory?(project_directory)
        puts "ERROR: The project folder '#{project_directory}' doesn't exist."
        exit -12
    end

    unless File.exists?(project_filepath)
        puts "ERROR: The project file '#{project_filepath}' doesn't exist."
        exit -12
    end

    project = Xcodeproj::Project.open(project_filepath)
    target = project.targets.find { |t| t.name == target_name }
    if target.nil?
        puts "ERROR: Unable to find target '#{target_name}'!"
        exit -12
    end

    target.build_configurations.find { |c| c.name == project_configuration }
end

project_filepath = ARGV[0].to_s
target_name = ARGV[1].to_s 
project_configuration = ARGV[2].to_s
key = ARGV[3].to_s

configuration = self.get_config_obj(project_filepath, target_name, project_configuration)
if configuration.nil?
    puts "ERROR: Unable to find configuration '#{project_configuration}'!"
    exit -12
end

puts configuration.build_settings[key]
