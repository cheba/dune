module Dune
  module Stanzas
    class InitialPresence < Stanza
      matcher -> n {
        n.name == 'presence' && n['to'].nil? && n['type'].nil?
      }

      def response

      end
    end
  end
end
