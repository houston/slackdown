require "slackdown/version"
require "kramdown"
require "kramdown/converter/slack"

module Slackdown

  def self.convert(markdown, options={})
    Kramdown::Document.new(markdown.to_s, options.merge(input: "GFM")).to_slack
  end

end
