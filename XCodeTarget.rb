require './XCodeFile'

# Represents a target in a XCode project
class XCodeTarget
  attr_reader :name, :is_test_target

  def initialize(target)
    @target = target
    @name = target.display_name
    @is_test_target = target.test_target_type?
  end

  # Returns [String]
  def dependency_list
    @target.dependencies.map(&:display_name)
  end

  # Returns [String] of file names
  def file_name_list
    @target.source_build_phase.file_display_names
  end

  # Returns [XCodeFile]
  def files
    @target.source_build_phase.files.map { |build_file| XCodeFile.new(build_file) }
  end

  # Returns [String] of all the unit imports statements in the target
  def all_unique_imports
    files.map(&:all_imports).flatten.uniq
  end

  # Returns names of files with duplicates imports.
  def files_with_duplicate_imports
    files.select(&:has_duplicate_import?)
  end

  # Returns the description of the object
  def to_s
    "Target - #{@name}"
  end

  # Returns the unused dependencies on the target
  def unused_dependencies_list
    imports = all_unique_imports.map { |import| import.split.last }
    dependency_list - imports
  end

  # Removes all the duplicate import statements from all the files linked to the target
  def remove_duplicate_imports
    files.each(&:remove_duplicate_imports)
  end
end
