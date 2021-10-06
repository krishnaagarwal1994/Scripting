# Represents a normal swift file present in Xcode.
class XCodeFile
  attr_reader :name, :path

  # Initializer which takes build file as an argument
  # @return [XCodeFile]
  def initialize(build_file)
    @name = build_file.file_ref.display_name
    @path = build_file.file_ref.real_path.to_s
  end

  # Method to return all the imports including the @testable import present in the file
  # @return [Array<String>]
  def all_imports
    File.foreach(@path).grep(/^import|^@testable import/).flatten
  end

  # Returns true is the file contains any duplicate import statement
  # @return [Boolean]
  def has_duplicate_import?
    duplicate_imports_info.length > 0
  end

  # Method to return the description of the object when printed.
  def to_s
    @name
  end

  # Prints the info for the duplicate imports in the file
  # format - {import_name} : {number_of_times_of_import}
  def print_duplicate_imports_info
    if has_duplicate_import?
      puts "#{@name}\n"
      duplicate_imports_info.each { |key, value| puts "#{key} - #{value} times" }
      puts "\n"
    end
  end

  # Removes all the duplicate imports from the file
  def remove_duplicate_imports
    duplicate_imports_mapping = duplicate_imports_info
    duplicate_imports = duplicate_imports_mapping.keys
    file_lines = IO.readlines(@path, chomp: true).select do |line|
      if duplicate_imports.include? line
        if duplicate_imports_mapping[line] <= 1
          line
        else
          duplicate_imports_mapping[line] = duplicate_imports_mapping[line] - 1
          nil
        end
      else
         line
      end
    end
    File.open(@path, 'w') do |file|
      file.puts file_lines
    end
  end

  private

  # Returns the mapping of the duplicate import statements
  # @return [[String: Integer]]
  def duplicate_imports_info
    import_frequency_mapping = {}
    all_imports.uniq.each do |item|
      item_occurrence = all_imports.count(item)
      if item_occurrence > 1
        import_frequency_mapping[item.chomp] = item_occurrence
      end
    end
    import_frequency_mapping
  end
end

#commented by madhur
