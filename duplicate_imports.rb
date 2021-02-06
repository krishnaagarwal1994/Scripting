# frozen_string_literal: true
require 'xcodeproj'
require './XCodeTarget'
require './XCodeProject'
project_name = 'Payments'
$project_path = "../../paxios/pax-ios/src/Payments/#{project_name}.xcodeproj"

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

def load_xcode_project
  project = XCodeProject.new($project_path)
  puts "Duplicate imports info: \n\n"
  project.non_test_targets.each do |target|
    # log_duplicates_imports(target)
    files_with_duplicate_import(target)
  end
  # Testing
  # log_duplicates_imports(project.get_target_by_name('PaymentsCashout'))
end

load_xcode_project
