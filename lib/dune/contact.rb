require 'dune/jid'
require 'yaml'

module Dune
  class Contact

    def initialize(jid, pending = true, subscription = 'none', name = nil, groups = [])
      @jid = JID.new(jid)
      @pending = pending
      @subscription = subscription
      @name = name
      @groups = groups
    end

    attr_accessor :jid, :pending

    def name
      @name || jid.identifier
    end
    attr_writer :name

    def subscription
      @subscription || 'none'
    end

    def subscription=(sub)
      if %w[none to from both].include? sub.to_s
        @subscription = sub
      else
        raise ArgumentError
      end
    end

    def groups
      @groups || []
    end

    def groups=(*params)
      @groups = params.flatten
    end

    def attributes
      {
        jid: jid.bare,
        name: name,
        pending: pending,
        subscription: subscription,
        groups: YAML.dump(groups)
      }
    end

    def hash
      [
        jid.bare,
        name,
        pending,
        subscription,
        groups
      ].hash
    end
  end
end
