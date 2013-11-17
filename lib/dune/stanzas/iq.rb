
module Dune
  module Stanzas
    class IQ < Stanza
      def initialize(element, stream)
        super

        if @element.name != 'iq'
          raise "This is not an IQ stanza"
        end

        if @element['id'].nil?
          raise "ID attribute is missing"
        end
      end

      private

      def iq(type, &block)
        document = Nokogiri::XML::Document.new
        element = document.create_element('iq') do |el|
          el['type'] = type
          el['id'] = @element['id']
        end
        yield element, document if block_given?
        element
      end
    end
  end
end
