require 'rubygems'
require 'test/unit'
require 'fileutils'
require 'shoulda'

class IntegrationTest < Test::Unit::TestCase

  # This is slow, and Test:Unit does not have "before/after :all" method, so I'm using a single testcase for multiple tests
  should "be able to send a build request, have it run and show the results" do
    system "mkdir -p tmp/runner; cp -rf test/fixtures/local tmp/local"
    system "export INTEGRATION_TEST=true; bin/testbot --runner --connect 127.0.0.1 --working_dir tmp/runner &> /dev/null"
    system "export INTEGRATION_TEST=true; bin/testbot --server &>/dev/null"
 
    # For debug
    # Thread.new do
    #   system "export INTEGRATION_TEST=true; bin/testbot --runner --connect 127.0.0.1 --working_dir tmp/runner --foreground"
    # end
    # Thread.new do
    #   system "export INTEGRATION_TEST=true; bin/testbot --server --foreground"
    # end

    sleep 1.0
    result = `cd tmp/local; INTEGRATION_TEST=true ruby ../../lib/requester.rb`
  
    # Should include the result from script/spec
    #puts result.inspect
    assert result.include?('script/spec got called with ["-O", "spec/spec.opts", "spec/models/house_spec.rb", "spec/models/car_spec.rb"]')
  
    # Should not include ignored files
    assert !File.exists?("tmp/server/log/test.log")
    assert !File.exists?("tmp/server/tmp/restart.txt")
    assert !File.exists?("tmp/runner/local_rsync/log/test.log")
    assert !File.exists?("tmp/runner/local_rsync/tmp/restart.txt")
  end
  
  def teardown
    system "bin/testbot --server stop &>/dev/null"
    system "bin/testbot --runner stop &>/dev/null"
    FileUtils.rm_rf "tmp"
  end

end
