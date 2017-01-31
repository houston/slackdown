require "test_helper"

class SlackdownTest < Minitest::Test

  should "convert escaped characters without escaping" do
    assert_converts '\*' => "*",
                    '\`' => "`",
                    '\_' => "_",
                    '\#' => "#",
                    '\+' => "+",
                    '\!' => "!"
  end

  should "convert typographical symbols" do
    assert_converts '1---2' => "1—2",
                    '1--2' => "1–2",
                    '<< x' => "« x",
                    'x >>' => "x »"
  end

  should "convert HTML entities" do
    assert_converts "&lt;" => "<",
                    "&times;" => "×"
  end

  should "ignore single line breaks" do
    assert_converts "line one\nline two" => "line one line two"
  end

  should "treat multiple line breaks as a single paragraph break" do
    assert_converts "line one\n\n\n\nline two" => "line one\n\nline two"
  end

  should "wrap bold text in a single pair of asterisks" do
    assert_converts "**bold**" => "*bold*",
                    "__bold__" => "*bold*",
                    "<b>bold</b>" => "*bold*",
                    "<strong>bold</strong>" => "*bold*",
                    "**bo\nld**" => "*bo ld*"
  end

  should "wrap italic text in a single pair of underscores" do
    assert_converts "*italic*" => "_italic_",
                    "_italic_" => "_italic_",
                    "<i>italic</i>" => "_italic_",
                    "<em>italic</em>" => "_italic_",
                    "_bo\nld_" => "_bo ld_"
  end

  should "wrap struck-through text in a single pair of tildes" do
    assert_converts "~~strikethrough~~" => "~strikethrough~",
                    "<del>strikethrough</del>" => "~strikethrough~"
  end

  should "wrap inline code blocks in backticks" do
    assert_converts "`code`" => "`code`",
                    "<code>code</code>" => "`code`"
  end

  should "not process code within codeblocks" do
    assert_converts <<~Markdown => <<~TEXT
      ```
      <p>
          <b>Bold</b> <i>Italic</i>
      </p>
      ```
    Markdown
      ```
      <p>
          <b>Bold</b> <i>Italic</i>
      </p>
      ```
    TEXT
  end

  should "convert headers to bold paragraphs with space before them" do
    assert_converts "# H1\nParagraph" => "\n\n*H1*\nParagraph",
                    "## H2\nParagraph" => "\n\n*H2*\nParagraph",
                    "### H3\nParagraph" => "\n\n*H3*\nParagraph",
                    "#### H4\nParagraph" => "\n\n*H4*\nParagraph",
                    "##### H5\nParagraph" => "\n\n*H5*\nParagraph",
                    "###### H6\nParagraph" => "\n\n*H6*\nParagraph"
  end

  should "remove the language name from fenced codeblocks" do
    assert_converts "```ruby\nputs 5\n```" => "```\nputs 5\n```"
  end

  should "replace images with their URL (Slack will unfurl them)" do
    assert_converts "![Logo](http://github.com/logo.png)" => "http://github.com/logo.png",
                    '<img src="http://github.com/logo.png" />' => "http://github.com/logo.png"
  end

  should "replace links with their URL (Slack will unfurl them)" do
    assert_converts "[Google](http://github.com)" => "http://github.com",
                    '<a href="http://github.com" />' => "http://github.com"
  end

  should "strip unrecognized HTML tags" do
    assert_converts "<article>Text</article>" => "Text"
  end

  should "convert unordered lists" do
    assert_converts <<~Markdown => <<~TEXT
      List:
       - one
       - two
       - three
    Markdown
      List:

        •  one
        •  two
        •  three
    TEXT
  end

  should "convert ordered lists" do
    assert_converts <<~Markdown => <<~TEXT
      List:
       1. one
       1. two
       1. three
      line two of item three

      Afterwards
    Markdown
      List:

        1. one
        2. two
        3. three line two of item three

      Afterwards
    TEXT
  end

  should "convert blockquotes" do
    assert_converts <<~Markdown => <<~TEXT
      Paragraph
      > Quote
      Line two of quote

      Afterwards
    Markdown
      Paragraph

      > Quote Line two of quote

      Afterwards
    TEXT
  end

  should "ignore comments" do
    assert_converts "This is a {::comment}para{:/}graph." => "This is a graph."
  end

  should "ignore abbreviations" do
    assert_converts "HTML is easy\n\n*[HTML]: HyperText Markup Language" => "HTML is easy"
  end

  should "convert horizontal rules" do
    assert_converts <<~Markdown => <<~TEXT
      Paragraph
      * * *
      Paragraph
    Markdown
      Paragraph

      ----------------------------------------------

      Paragraph
    TEXT
  end

private

  def convert(markdown)
    Slackdown.convert(markdown)
  end

  def assert_converts(hash)
    hash.each do |markdown, expected|
      assert_equal expected.strip, convert(markdown).strip
    end
  end

end
