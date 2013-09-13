require 'dune/jid'

module Dune
  module Stanzas
    class RosterSet < IQ

      matcher -> n {
        n.name == 'iq' && n['type'] == 'set' && n.xpath('ns:query', 'ns' => NAMESPACES[:roster]).any?
      }

      def response
        item_el = @element.xpath('.//ns:item', ns: NAMESPACES[:roster])[0]
        destination = JID.new(item_el['jid'])

        contact = @stream.user.roster[destination] || Contact.new(destination)

        groups = @element.xpath('.//ns:item/ns:group', ns: NAMESPACES[:roster]).map { |el| el.text }

        if groups.any?
          contact.groups = groups
        end

        name = item_el['name']
        if name
          contact.name = name
        end

        contact = @stream.user.roster << contact

        doc = Nokogiri::XML::Document.new
        doc.create_element('iq') do |el|
          el['type'] = 'set'
          el['to'] = @stream.user.jid.bare

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
