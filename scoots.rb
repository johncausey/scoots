#!/usr/bin/env ruby
Dir.chdir(File.expand_path('../'))

require 'socket'
require 'open-uri'
require 'yaml'
require 'mechanize'
require 'nokogiri'

require_relative 'lib/vocals'
require_relative 'lib/urlhandlers'
require_relative 'lib/decision'

class Settings
  attr_accessor :server_to_join, :port_to_use, :channel_to_join, :bot_name_to_use

end

###
### Could use a heavy refactor to control Scoots autojoining the channel after a timeout only on specific actions.
###

data = YAML::load(File.open(File.expand_path('../settings/settings.yml', __FILE__)))

class ScootsBot < Settings

  include Vocals, UrlHandlers, Decision

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
        decide(content)
      end

      if msg.match(/^ERROR :Closing Link: (.*)$/)
        sleep(20)
        restart
      end
    end
  end

  def quit
    say "PART ##{@channel} :Bye!"
    say 'QUIT'
  end

  def restart
    data = YAML::load(File.open(File.expand_path('../settings/settings.yml', __FILE__)))
    scoots = ScootsBot.new(
      data.first.server_to_join,
      data.first.port_to_use,
      data.first.channel_to_join,
      data.first.bot_name_to_use)

    trap("INT"){ $scoots.quit }

    scoots.run
  end

end

###
### Scoots can perform dirty logging of your channel. Note that public logging of many IRC channels is prohibited.
###

$stdout.reopen(File.expand_path('../logs/normaloutput.txt', __FILE__), "w")
$stderr.reopen(File.expand_path('../logs/errors.txt', __FILE__), "w")

puts 'stdout for scoots operation'
warn 'stderr for broken scoots'


scoots = ScootsBot.new(
  data.first.server_to_join,
  data.first.port_to_use,
  data.first.channel_to_join,
  data.first.bot_name_to_use)

trap("INT"){ $scoots.quit }

scoots.run

