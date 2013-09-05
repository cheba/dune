module Dune
  class JID
    # http://tools.ietf.org/html/rfc6122#appendix-A
    IDENTIFIER_PREP = /[[:cntrl:] "&'\/:<>@]/

    # http://tools.ietf.org/html/rfc3454#appendix-C
    DOMAIN_PREP = /[[:cntrl:] ]/

    # http://tools.ietf.org/html/rfc6122#appendix-B
    RESOURCE_PREP = /[[:cntrl:]]/

    attr_accessor :identifier, :domain, :resource

    def initialize(identifier, domain = nil, resource = nil)

      if domain.nil? && resource.nil?
        parse(identifier)
      else
        @identifier = (identifier || '')
        @domain = (domain || '')
        @resource = (resource || '')
      end

      #[@identifier, @domain].each {|part| part.downcase! if part }
    end

    def valid?
      !(
        @identifier.length > 1023 ||
        @domain.length > 1023 ||
        @resource.length > 1023 ||
        @domain.empty? ||
        @identifier =~ IDENTIFIER_PREP ||
        @domain =~ DOMAIN_PREP ||
        @resource =~ RESOURCE_PREP
      )
    end

    def full
      s = bare

      unless @resource.empty?
        s = "#{s}/#{@resource}"
      end

      s
    end
    alias_method :to_s, :full

    def bare
      s = @domain

      unless @identifier.empty?
        s = "#{@identifier}@#{s}"
      end

      s
    end

    private

    def parse(jid)
      s, resourcepart = jid.split('/', 2)
      if resourcepart.nil?
        resourcepart = ''
      end

      localpart, domainpart = s.split('@', 2)
      if domainpart.nil?
        domainpart = localpart
        localpart = ''
      end

      @identifier = localpart.strip
      @domain = domainpart.strip
      @resource = resourcepart.strip
    end
  end
end
