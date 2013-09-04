module Dune
  class User
    def self.authenticate(jid, password)
      puts "Authenticating #{jid} with #{password}"
      # FIXME: do the actual lookup
      new(jid)
    end

    attr_reader :jid

    def initialize(jid)
      @jid = jid
    end
  end
end
