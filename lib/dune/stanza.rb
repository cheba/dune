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

    def self.for(element, stream)
      stanza_class = Stanzas.constants.map do |const_name|
        Stanzas.const_get(const_name)
      end.detect do |klass|
        if klass.is_a? Class
          case klass.matcher
          when String
            element.xpath(klass.matcher).any?
          when Proc
            klass.matcher.call(element)
          end
        end
      end

      # This class is essentially a Null Object. Use it for unknown stanzas.
      stanza_class ||= self

      if stanza_class
        stanza_class.new(element, stream)
      else
        nil
      end
    end

    def initialize(element, stream)
      @element = element
      @stream = stream
    end

    def response
      ''
    end

    private

    def iq(type, &block)
      if @element.name != 'iq'
        raise "This is not an IQ stanza"
      end
      document = Nokogiri::XML::Document.new
      element = document.create_element('iq') do |el|
        el['type'] = type
        el['id'] = @element['id']
      end
      yield element, document
      element
    end
  end
end

require 'dune/stanzas/starttls'
require 'dune/stanzas/auth_plain'
require 'dune/stanzas/bind'
