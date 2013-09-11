require 'dune/jid'

module Dune
  module Stanzas
    class Subscribe < Stanza

      matcher -> n {
        n.name == 'presence' && n['type'] == "subscribe"
      }

      def response
        destination = JID.new(@element['to'])
        @element['to'] = destination.bare

        contact = @stream.server.storage.subscribe(@stream.user.jid, destination)

        @stream.server.router.route(@element)


        doc = Nokogiri::XML::Document.new
        doc.create_element('iq') do |el|
          el['type'] = 'set'
          el['to'] = @stream.user

          el << doc.create_element('query', xmlns: NAMESPACES[:roster]) do |query|
              query << doc.create_element('item', jid: contact.jid.bare, name: contact.name, subscription: contact.subscription) do |item|
                if contact.pending
                  item['ask'] = 'subscribe'
                end
                contact.groups.each do |group|
                  item << doc.create_element('group', group)
                end
              end
          end
        end
      end
    end
  end
end
