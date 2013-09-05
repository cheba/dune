require 'dune/jid'

module Dune
  class Contact

    def jid
      JID.new('cheba@pointlessone.org')
    end

    def name
      jid.identifier
    end

    def state
      'both'
    end

    def groups
      ['devs', 'Ruby']
    end

    def hash
      [
        jid.bare,
        name,
        state,
        groups
      ].hash
    end
  end
end
