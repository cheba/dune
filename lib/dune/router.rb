module Dune
  class Router
    def initialize
      @streams = []
    end

    def <<(stream)
      unless @streams.include? stream
        stream.server.logger.debug "Adding stream: #{stream.inspect}"
        @streams << stream
      else
        stream.server.logger.debug "Stream is already in router: #{stream.inspect}"
      end
      self
    end

    def >>(stream)
      stream.server.logger.debug "Removig stream: #{stream.inspect}"
      @streams.delete(stream)
    end

    def stream_for(jid, bare = false)
      @streams.find do |s|
        if bare
          s.user.jid.bare == jid.bare
        else
          s.user.jid.full == jid.full
        end
      end
    end

    def route(stanza)

    end

    def shutdown
      @streams.each do |stream|
        stream.close
        self >> stream
      end
    end
  end
end
