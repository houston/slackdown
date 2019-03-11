require "slackdown/version"
require "kramdown"
require "kramdown/converter/slack"
require "kramdown-parser-gfm"

module Slackdown

  def self.convert(markdown, options={})
    Kramdown::Document.new(markdown.to_s, options.merge(input: "GFM")).to_slack
  end

end
