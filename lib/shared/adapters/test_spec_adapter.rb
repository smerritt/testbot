require File.expand_path(File.join(File.dirname(__FILE__), "/helpers/ruby_env"))

class TestSpecAdapter
  
  def self.command(project_path, ruby_interpreter, files)
    ruby_command = RubyEnv.ruby_command(project_path, :ruby_interpreter => ruby_interpreter)
    "#{ruby_command} " + files.map {|f| "'#{f}'" }.join(" ")
  end
  
  def self.test_files(dir)
    Dir["#{dir}/#{file_pattern}"]
  end

  def self.get_sizes(files)
    files.map { |file| File.stat(file).size }
  end
  
  def self.requester_port
    22312
  end
  
  def self.pluralized
    'testspecs'
  end
  
  def self.base_path
    type
  end
  
  def self.name
    'test/spec'
  end
  
  def self.type
    'testspec'
  end  
  
private

  def self.file_pattern
    '**/**/*_testspec.rb'
  end
  
end
