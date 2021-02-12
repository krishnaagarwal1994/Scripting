# frozen_string_literal: true
require './xcode_project_utils'

if ARGV.length == 1
  project_path = ARGV[0]
  project_utils = XcodeProjectUtils.new(project_path)
  project_utils.log_all_duplicates_imports
else
  puts "Enter the project path"
end

