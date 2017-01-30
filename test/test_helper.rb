$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "slackdown"

require "minitest/reporters/turn_reporter"
MiniTest::Reporters.use! Minitest::Reporters::TurnReporter.new

require "pry"
require "shoulda/context"
require "minitest/autorun"
