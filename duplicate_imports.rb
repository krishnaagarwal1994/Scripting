# frozen_string_literal: true
require 'xcodeproj'
require './XCodeTarget'
require './XCodeProject'


def log_duplicates_imports(target)
  files_with_duplicate_imports = target.files_with_duplicate_imports
  unless files_with_duplicate_imports.empty?
    puts "Files with Duplicates imports in #{target.name} \n----------------------------------------"
    files_with_duplicate_imports.each(&:print_duplicate_imports_info)
  end
end

def files_with_duplicate_import(target)
  duplicates = target.files_with_duplicate_imports
  unless duplicates.empty?
    puts "#{target.name} \n--------------"
    puts duplicates
    puts "\n"
  end
end

def target_dependencies(target)
  puts "#{target.name} dependencies:- "
  puts target.dependency_list
  puts "\n"
end

def print_unused_dependencies_list(target)
  unused_dependencies = target.unused_dependencies_list
  unless unused_dependencies.empty?
    title = "#{target.name} with unused dependencies:-"
    puts title
    puts '-' * title.length
    puts unused_dependencies
    puts "\n"
  end
end

def load_xcode_project(project_path)
  project = XCodeProject.new(project_path)
  project.non_test_targets.each do |target|
    # print_unused_dependencies_list(target)
    log_duplicates_imports(target)
  end
end

def delete_duplicate_imports(project_path)
  project = XCodeProject.new(project_path)
  project.non_test_targets.each { |target| target.files.each(&:remove_duplicate_imports) }

  # Test code
  # default_target = project.get_target_by_name("target_name")
  # result_file = default_target.files.select{ |file| file.name == 'ToastNotificationsStackView.swift'}.first
  # result_file.remove_duplicate_imports
  # # default_target.files.each(&:remove_duplicate_imports)
end

if ARGV.length == 1
  # load_xcode_project(ARGV[0])
  delete_duplicate_imports(ARGV[0])
elsif
puts "Enter the project path"
end

