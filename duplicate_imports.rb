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

def load_xcode_project(project_path)
  project = XCodeProject.new(project_path)
  puts "Duplicate imports info: \n\n"
  project.non_test_targets.each do |target|
    # log_duplicates_imports(target)
    files_with_duplicate_import(target)
  end
end

if ARGV.length == 1
  load_xcode_project(ARGV[0])
elsif
puts "Enter the project path"
end

