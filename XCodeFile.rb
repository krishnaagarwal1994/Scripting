# Represents a normal swift file present in Xcode
class XCodeFile
  attr_reader :name, :path
  def initialize(build_file)
    @name = build_file.file_ref.display_name
    @path = build_file.file_ref.real_path.to_s
  end

  def all_imports
    File.foreach(@path).grep(/import/).flatten
  end

  def duplicate_imports
    #calculate the duplicate element frequency
    import_frequency_mapping = {}
    all_imports.uniq.each do |item|
      item_occurrence = all_imports.count(item)
      if item_occurrence > 1
        import_frequency_mapping[item.chomp] = item_occurrence
      end
    end
    import_frequency_mapping
  end

  def has_duplicate_import?
    duplicate_imports.length > 0
  end

  def to_s
    @name
  end

  def print_duplicate_imports_info
    if has_duplicate_import?
      puts "#{@name}\n"
      duplicate_imports.each { |key, value| puts "#{key} - #{value} times" }
      puts "\n"
    end
  end
end