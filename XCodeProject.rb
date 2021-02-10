require './XCodeTarget'

# Represents and XCode project
class XCodeProject
  attr_reader :all_targets, :test_targets, :non_test_targets # [XCodeTargets]

  def initialize(project_path)
    project = load_project_from_path(project_path)
    @all_targets = load_targets_from_project(project).map { |t| XCodeTarget.new(t)}
    @test_targets = filter_test_targets(@all_targets)
    @non_test_targets = @all_targets - @test_targets
  end

  def get_target_by_name(target_name)
    targets = @all_targets.select{ |target| target.name == target_name}
    if targets.empty?
      raise StandardError, 'Target Name not found'
    else
      targets.first
    end
  end

  private

  def load_project_from_path(project_path)
    Xcodeproj::Project.open(project_path)
  end

  def load_targets_from_project(project)
    project.native_targets
  end

  def filter_test_targets(targets)
    targets.select(&:is_test_target)
  end
end