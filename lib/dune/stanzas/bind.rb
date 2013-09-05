require 'securerandom'
require 'nokogiri'

module Dune
  module Stanzas
    class Bind < IQ

      matcher -> n {
        n.name == 'iq' && n['type'] == 'set' && n.xpath('ns:bind', 'ns' => NAMESPACES[:bind]).any?
      }

      def response
        resource = @element.xpath('//ns:resource', 'ns' => NAMESPACES[:bind]).text

        @stream.bind resource

        iq 'result' do |el, doc|
          el << doc.create_element('bind') do |bind|
            bind.add_namespace(nil, NAMESPACES[:bind])
            bind << doc.create_element('jid', @stream.user.jid.full)
          end
        end
      end
    end
  end
end
