#!/usr/bin/env ruby

require 'socket'
require 'uri'
require 'yaml'
require 'mechanize'

require_relative 'lib/vocals'
require_relative 'lib/urlhandlers'

class Settings
  attr_accessor :server_to_join, :port_to_use, :channel_to_join, :bot_name_to_use

end

FILENAME = 'settings.yml'
data = YAML::load(File.open(FILENAME))

class ScootsBot < Settings

  include Vocals, UrlHandlers

  def initialize(server, port, channel, bot_name)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK #{bot_name}"
    say "USER ircbot 0 * IRCBot"
    say "JOIN ##{@channel}"
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
          repeats(content)
        end
      end
    end
  end

  def quit
    say "PART ##{@channel} :Bye!"
    say 'QUIT'
  end
end


scoots = ScootsBot.new(data.first.server_to_join, data.first.port_to_use, data.first.channel_to_join, data.first.bot_name_to_use)

trap("INT"){ scoots.quit }

scoots.run
