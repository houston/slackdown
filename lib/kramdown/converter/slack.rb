module Kramdown
  module Converter

    # Converts a Kramdown::Document to Slack.
    # https://api.slack.com/docs/message-formatting
    class Slack < Base

      def convert(el)
        if el.type == :html_element
          converter = :"convert_html_#{el.value}"
          converter = :convert_html_element unless respond_to? converter
        else
          converter = :"convert_#{el.type}"
        end
        send(converter, el)
      end

      def inner(el)
        el.children.map { |el| convert(el) }.join
      end
      alias :convert_root :inner

      def convert_p(el)
        "#{inner(el).strip.gsub(/\n/, " ")}\n\n"
      end

      def convert_text(el)
        el.value
      end
      alias :convert_abbreviation :convert_text

      def convert_blank(el)
        ""
      end
      alias :convert_br :convert_blank
      alias :convert_comment :convert_blank

      def convert_html_br(el)
        "\n"
      end

      def convert_strong(el)
        "*#{inner(el)}*"
      end
      alias :convert_html_b :convert_strong
      alias :convert_html_strong :convert_strong

      def convert_em(el)
        "_#{inner(el)}_"
      end
      alias :convert_html_i :convert_em
      alias :convert_html_em :convert_em

      def convert_del(el)
        "~#{inner(el)}~"
      end
      alias :convert_html_del :convert_del

      def convert_codespan(el)
        "`#{el.value}`"
      end
      alias :convert_html_code :convert_codespan

      def convert_blockquote(el)
        "> #{inner(el)}"
      end

      def convert_codeblock(el)
        "```\n#{el.value}```\n\n"
      end

      def convert_a(el)
        content = inner(el)
        return el.attr["href"] if content.nil? || content == ""
        "<#{el.attr["href"]}|#{content}>"
      end
      alias :convert_html_a :convert_a

      def convert_img(el)
        el.attr["src"]
      end
      alias :convert_html_img :convert_img

      def convert_ul(el)
        @bullet = UlBulletGenerator.new
        "#{inner(el)}\n"
      end
      alias :convert_html_ul :convert_ul

      def convert_ol(el)
        @bullet = OlBulletGenerator.new
        "#{inner(el)}\n"
      end
      alias :convert_html_ol :convert_ol

      def convert_li(el)
        "  #{bullet.next} #{inner(el).strip}\n"
      end
      alias :convert_html_li :convert_li

      def convert_header(el)
        "\n\n#{convert_strong(el)}\n"
      end
      alias :convert_html_h1 :convert_header
      alias :convert_html_h2 :convert_header
      alias :convert_html_h3 :convert_header
      alias :convert_html_h4 :convert_header
      alias :convert_html_h5 :convert_header
      alias :convert_html_h6 :convert_header

      def convert_hr(el)
        "----------------------------------------------\n\n"
      end

      def convert_smart_quote(el)
        SMART_QUOTES.fetch(el.value)
      end

      def convert_typographic_sym(el)
        TYPOGRAPHIC_SYMBOLS.fetch(el.value)
      end

      def convert_entity(el)
        el.value.char
      end



      def __convert_todo(el)
        inner(el)
      end
      alias :convert_html_element :__convert_todo

      # The following are all tags converted by Kramdown::Converter::Html
      alias :convert_dd :__convert_todo
      alias :convert_dl :__convert_todo
      alias :convert_dt :__convert_todo
      alias :convert_footnote :__convert_todo
      alias :convert_math :__convert_todo
      alias :convert_raw :__convert_todo
      alias :convert_table :__convert_todo
      alias :convert_tbody :__convert_todo
      alias :convert_td :__convert_todo
      alias :convert_tfoot :__convert_todo
      alias :convert_thead :__convert_todo
      alias :convert_tr :__convert_todo
      alias :convert_xml_comment :__convert_todo
      alias :convert_xml_pi :__convert_todo

    private
      attr_reader :bullet

      class UlBulletGenerator
        def next; "• "; end
      end

      class OlBulletGenerator
        def initialize; @i = 0; end
        def next; "#{@i += 1}."; end
      end

      SMART_QUOTES = {
        lsquo: "‘",
        rsquo: "’",
        ldquo: "“",
        rdquo: "”" }.freeze

      TYPOGRAPHIC_SYMBOLS = {
        mdash: "—",
        ndash: "–",
        hellip: "...",
        laquo_space: "« ",
        raquo_space: " »",
        laquo: "«",
        raquo: "»" }.freeze

    end
  end
end
