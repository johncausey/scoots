class ScootsBot < Settings
  include Vocals, UrlHandlers, Decision

  def initialize(server, port, channel, botname)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK #{botname}"
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
    end
  end

  def quit
    say "PART ##{@channel} :Bye!"
    say 'QUIT'
  end

end
