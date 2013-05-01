#!/usr/bin/env ruby

module Vocals

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def say_to_chan(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end

  def repeats(content)
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
        say_to_chan("I'm scoots, I'm here to provide URL information inside the chat window.")
      when "!servers"
        say_to_chan("Here are some great hosting options: http://www.linode.com/ http://www.site5.com/p/ruby/ https://www.engineyard.com/ https://www.heroku.com/")
      when "!music"
        say_to_chan("http://www.youtube.com/watch?v=abSadQcziEM")
      when "!help"
        say_to_chan("Hey! I'm still being worked on at the moment so I apologize if I go offline or break. Right now I can check page titles; more ability will be added soon, such as displaying image, github, and video data.")
    end
  end

end
