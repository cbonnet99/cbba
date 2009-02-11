class HtmlToPdfConverter
  HTML_TO_PDF_SUBS = [
    [/\t/, '   '],
    [/&nbsp;/," "],
    [/\r\n/, "\n"],
    [/<ul>\n<li>/, "<ul><li>"],
    [/<\/li>\n<li>/, "</li><li>"],
    [/<\/li>\n<\/ul>/, "</li></ul>"],
    [/(<p>)(.*?)(<\/p>)(\n*)/m, "\\2\n"],
    [/<br \/>/, "\n"],
    [/(<li>)(.*?)(<\/li>)(\n*)/m,"<C:bullet/>\\2\n"],
    [/(<strong>)(.*?)(<\/strong>)/m, "<b>\\2</b>"],
    [/(<em>)(.*?)(<\/em>)/m, "<i>\\2</i>"],
    [/(<ul>)(.*?)(<\/ul>)/m, "\\2"],
  ]

  LEFTOVER_HTML_SUBS = [
    [/&ndash;/, "-"],
    [/&mdash;/, "-"],
    [/&lsquo;/, "'"],
    [/&rsquo;/, "'"],
    [/&ldquo;/, "\""],
    [/&rdquo;/, "\""],
    [/&hellip;/, "..."],
    [/&euro;/, "Euro"],
    [/&pound;/, "£"],
    ]
    def self.convert(html)
      self.substitute(escape(html), HTML_TO_PDF_SUBS)
    end

    private
    def self.escape(html)
      self.substitute(CGI.unescapeHTML(html), LEFTOVER_HTML_SUBS)
    end

    def self.substitute(html, substitutions)
      result = html
      substitutions.each {|from, to| result = result.gsub(from, to) }
      result
    end
  end