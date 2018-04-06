# Require everything directly under lib/

Dir[File.join(File.dirname(__FILE__), "../lib/*")].each do |lib_file|
  require lib_file
end

require "minitest/autorun"

# To see full test names when running tests:
#
# require "minitest/reporters"
# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
