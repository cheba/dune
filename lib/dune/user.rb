require 'dune/roster'

module Dune
  class User
    def self.authenticate(jid, password, server)
      server.logger.debug "Authenticating #{jid} with #{password}" # XXX Remember: you should never log user passwords
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
