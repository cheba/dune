require 'dune/roster'

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

    attr_reader :jid, :server, :roster

    def initialize(jid, server)
      @jid = jid
      @server = server
      @roster = Roster.new(self)
    end
  end
end
