Dir.chdir(File.expand_path('../'))
$stderr.reopen(File.expand_path('../logs/errors.txt', __FILE__), "w")
warn 'stderr for broken scoots'

require 'socket'
require 'open-uri'
require 'yaml'
require 'mechanize'
require 'nokogiri'

require_relative 'settings/settings'
require_relative 'lib/vocals'
require_relative 'lib/urlhandlers'
require_relative 'lib/decision'
require_relative 'lib/scootsbot'

trap("INT"){ $scoots.quit }

class Launch
  def self.scoots
    data = YAML::load(File.open(File.expand_path('../settings/settings.yml', __FILE__)))
    scoots = ScootsBot.new( data.first.server, data.first.port, data.first.channel, data.first.botname )
    scoots.run
  end
end

Launch::scoots
