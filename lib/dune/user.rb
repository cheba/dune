module Dune
  class User
    def self.authenticate(jid, password, server)
      puts "Authenticating #{jid} with #{password}"
      # FIXME: do the actual lookup
      if server.storage.authenticate_user jid, password
        new(jid, server)
      else
        nil
      end
    end

    attr_reader :jid

    def initialize(jid, server)
      @jid = jid
      @server = server
    end
  end
end
