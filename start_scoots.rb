#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'mechanize'

channel_to_join = "scootstesting"
server_to_join = "irc.freenode.net"
port_to_use = "6667"

class ScootsBot

  def initialize(server, port, channel)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK scootsbot"
    say "USER ircbot 0 * IRCBot"
    say "JOIN ##{@channel}"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def say_to_chan(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
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

  def strip_link(text)
    link = /(http|www)\S+/.match(text)
    link
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

  def run
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      if msg.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1]

        if is_a_link(content)
          tell_chan_title(@strippedlink)
        else
          case content.strip
            when "!hello"
              say_to_chan("Hey!")
            when "!resources"
              say_to_chan("Some great rails resources can be found here: http://railsforzombies.org/ http://railscasts.com/ http://ruby.railstutorial.org/")
            when "!versions"
              say_to_chan("Here are some good stable versions: Rails 3.2.13 - Ruby 1.9.3-p392 or Ruby 2.0.0-p0. Ruby 2 is backwards compatible with Ruby 1.9.3.")
            when "!stack"
              say_to_chan("I like to use RVM for Ruby management and PostgreSQL as a database. SQLite3 is best used only in development.")
            when "!whatareyou"
              say_to_chan("I'm scootsbot! I'm here to provide URL information inside the chat window.")
            when "!servers"
              say_to_chan("Here are some great hosting options: http://www.linode.com/ http://www.site5.com/p/ruby/ https://www.engineyard.com/ https://www.heroku.com/")
            when "!music"
              say_to_chan("http://www.youtube.com/watch?v=abSadQcziEM")
            when "!help"
              say_to_chan("Hey! I'm still being worked on at the moment so I apologize if I go offline or break. Right now I can check page titles; more ability will be added soon, such as displaying image, github, and video data.")
          end
        end
      end
    end
  end

  def quit
    say "PART ##{@channel} :Bye!"
    say 'QUIT'
  end
end

scoots = ScootsBot.new(server_to_join, port_to_use, channel_to_join)

trap("INT"){ scoots.quit }

scoots.run
