module Dune
  module Stanzas
  end

  class Stanza
    def self.matcher(matcher = nil)
      if matcher
        @matcher = matcher
      else
        @matcher
      end
    end

    def initialize(element, stream)
      @element = element
      @stream = stream
    end

    def response
      @stream.server.logger.info(@stream.id) { "\e[33;1m" + "Unhandled stanza" + "\e[0m" }
      ''
    end

    def new_context(context)
      @stream.server.logger.info(@stream.id) { "\e[33;1m" + "Current context: #{context.inspect}" + "\e[0m" }
      context
    end
  end
end
