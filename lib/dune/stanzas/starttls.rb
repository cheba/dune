module Dune
  module Stanzas
    class StartTLS < Stanza

      matcher -> n {
        n.name == 'starttls'
      }

      def response
        if @stream.secure?
        else
          @stream.start_tls
          nil
        end
      end
    end
  end
end
