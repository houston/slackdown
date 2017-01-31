# Slackdown

Slackdown converts Markdown to [Slack's simpler markup syntax](https://get.slack.help/hc/en-us/articles/202288908-How-can-I-add-formatting-to-my-messages-).

Slackdown implements a converter for [kramdown](https://github.com/gettalong/kramdown).


## Usage

```ruby
require "slackdown"

Slackdown.convert(markdown_text)
```

If you're familiar with Kramdown, you can also do:

```ruby
require "kramdown/converter/slack"

Kramdown::Document.new(markdown_text, options).to_slack
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/houston/slackdown.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
