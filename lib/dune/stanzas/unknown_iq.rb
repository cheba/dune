require 'dune/stanzas/iq'

module Dune
  module Stanzas
    class UnknownIQ < IQ
      matcher -> n {
        n.name == 'iq'
      }

      def response
        super
        iq 'error' do |el, doc|
          el << doc.create_element('error') do |error|
            error['type'] = 'cancel'
            error << doc.create_element('feature-not-implemented', xmlns: NAMESPACES[:stanzas])
          end
        end
      end
    end
  end
end
