require 'xcodeproj'
require './XCodeTarget'
require './XCodeProject'

# A utility class to help with some basic operations
class XcodeProjectUtils
  attr_reader :project
  def initialize(project_path)
    @project_path = project_path
    @project = XCodeProject.new(project_path)
  end

  def log_all_duplicates_imports
    targets = @project.all_targets
    targets.each { |target| log_duplicates_imports(target) }
  end

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

  def remove_unused_dependencies(project_path)
    project = XCodeProject.new(project_path)
    project.non_test_targets.each(&:remove_unused_dependencies)
    project.save_project
  end

  def load_xcode_project(project_path)
    project = XCodeProject.new(project_path)
    project.non_test_targets.each do |target|
      print_unused_dependencies_list(target)
      # log_duplicates_imports(target)
    end
  end

  def delete_duplicate_imports(project_path)
    project = XCodeProject.new(project_path)
    project.all_targets.each(&:remove_duplicate_imports)
  end
end