require "slackdown/version"
require "kramdown"
require "kramdown/converter/slack"

module Slackdown

  def self.convert(markdown, options={})
    Kramdown::Document.new(markdown, options).to_slack
  end

end
