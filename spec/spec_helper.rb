require "debug"
require "rspec"
require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end


require './board'
require './game'
require './player'
require './ship'


RSpec.configure do |config|
  # allow "fit" examples
  config.filter_run_when_matching :focus

  config.mock_with :rspec do |mocks|
    # verify existence of stubbed methods
    mocks.verify_partial_doubles = true
  end
end
