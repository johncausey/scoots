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

  def tell_chan_title(text)
    begin title = Mechanize.new.get(text).title
      encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => ' ',       # Use a blank for those replacements
        :universal_newline => false      # Always break lines with \n
      }
      non_ascii_title = title.encode Encoding.find('ASCII'), encoding_options
      say_to_chan("#{non_ascii_title}")
    rescue
      say_to_chan("Sorry, I could not find a page title for this link.")
    end
  end

end
