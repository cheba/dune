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

      def new_context(context)
        if context == :unauthorized_client
          :authorization
        else
          :client
        end
      end
    end
  end
end
