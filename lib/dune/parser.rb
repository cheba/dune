require 'nokogiri'
require 'securerandom'
require 'dune/stanza'

module Dune
  class Parser < Nokogiri::XML::SAX::Document
    include Nokogiri::XML
    STREAM_NAME = 'stream'
    IGNORE = NAMESPACES.values_at(:client, :component, :server)


    def initialize(stream)
      @stream = stream

      @element = nil
      @parser = Nokogiri::XML::SAX::PushParser.new(self)
    end

    def <<(str)
      @parser << str
      self
    end

    def close_stream
      @stream.close
    end


    def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      if stream?(name, uri)
        write_stream_header attrs
      else
        element = reconstruct_element(name, attrs, prefix, uri, ns)
        if @element
          @element << element
        end
        @element = element
      end
    end

    def end_element_namespace(name, prefix=nil, uri=nil)
      if stream?(name, uri)
        puts "End of stream"
        close_stream
      elsif @element.parent
        @element = @element.parent
      else
        process_element @element
        @element = nil
      end
    end

    def characters(chars)
      if @element
        @element << Text.new(chars, @element.document)
      end
    end
    alias :cdata_block :characters

    private

    def stream?(name, uri)
      name == 'stream' && uri == NAMESPACES[:stream]
    end

    def reconstruct_element(name, attrs = [], prefix = nil, uri = nil, ns = [])
      ignored_namespaces = stream?(name, uri) ? [] : IGNORE
      doc = @element ? @element.document : Document.new
      element = doc.create_element(name) do |el|
        attrs.each { |attr| el[attr.localname] = attr.value }
        ns.each do |ns_prefix, ns_uri|
          el.add_namespace(ns_prefix, ns_uri) unless ignored_namespaces.include?(ns_uri)
        end
        el.namespace = el.add_namespace(prefix, uri) unless ignored_namespaces.include?(uri)
      end
      element
    end

    def error?(element)
      ns = element.namespace ? element.namespace.href : nil
      element.name == 'error' && ns == NAMESPACES[:stream]
    end

    def process_element(element)
      if error? element
        puts "ERROR"
        close_stream
      else
        @stream.write Stanza.for(element, @stream).response
      end
    end

    def write_stream_header(attrs)
      if domain_attr = attrs.find{|attr| attr.localname == 'to'}
        @stream.domain = domain_attr.value
      end
      @stream.id = SecureRandom.uuid

      attributes = {
        'xmlns' => NAMESPACES[:client],
        'xmlns:stream' => NAMESPACES[:stream],
        'xml:lang' => 'en',
        'id' => @stream.id,
        'from' => @stream.domain,
        'version' => '1.0'
      }

      if from_attr = attrs.find { |attr| attr.localname == 'from' }
        attributes['to'] = from_attr.value
      end

      @stream.write %Q(<?xml version="1.0" encoding="UTF-8" ?>\n<stream:stream %s>) % attributes.map { |k, v| %(#{k}="#{v}") }.join(' ')

      @stream.write(features)
    end

    def features
      doc = Document.new
      doc.create_element('stream:features') do |el|
        unless @stream.secure?
          el << doc.create_element('starttls') do |tls|
            tls.default_namespace = NAMESPACES[:tls]
            tls << doc.create_element('required')
          end
        else
          unless @stream.authenticated?
            el << doc.create_element('mechanisms') do |sasl|
              sasl.default_namespace = NAMESPACES[:sasl]
              %w[PLAIN].each do |mechanism|
                sasl << doc.create_element('mechanism', mechanism)
              end
            end
          else
            unless @stream.bound?
              el << doc.create_element('bind') do |sasl|
                sasl.default_namespace = NAMESPACES[:bind]
              end
            end
          end
        end
      end
    end
  end
end
