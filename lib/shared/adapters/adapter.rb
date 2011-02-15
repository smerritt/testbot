require File.dirname(__FILE__) + '/rspec_adapter'
require File.dirname(__FILE__) + '/cucumber_adapter'
require File.dirname(__FILE__) + '/test_unit_adapter'
require File.dirname(__FILE__) + '/test_spec_adapter'

class Adapter
  def self.all
    [ RSpecAdapter, CucumberAdapter, TestUnitAdapter, TestSpecAdapter ]
  end

  def self.find(type)
    case type.to_sym
    when :spec
      RSpecAdapter
    when :features
      CucumberAdapter
    when :test
      TestUnitAdapter
    when :testspec
      TestSpecAdapter
    else
      raise "Unknown adapter: #{type}"
    end
  end
end
