#!/usr/bin/env ruby
module UrlHandlers

  def strip_link(text)
    link = /(http|www)\S+/.match(text)
    link
  end

  def is_a_link(text)
    strippedlink = strip_link(text)
    if strippedlink.to_s.length >= 4
      @strippedlink = strippedlink
    end
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

  # Basic URL title login, also the fallback location for Decision.
  def tell_chan_title(text)
    begin
      title = Mechanize.new.get(text).title
      title = title.strip.gsub(/\s*\n+\s*/, " ")
      encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => ' ',       # Use a blank for those replacements
        :universal_newline => false      # Always break lines with \n
      }
      non_ascii_title = title.encode(Encoding.find('ASCII'), encoding_options) if title.length >= 5 and title.length <= 230
      reg_title = non_ascii_title[0..230] if non_ascii_title.length > 230
      if reg_title
        say_to_chan("Title - \2#{reg_title}\2")
      elsif non_ascii_title
        say_to_chan("Title - \2#{non_ascii_title}\2")
      else
        false
      end
    rescue
      false
    end
  end

end
