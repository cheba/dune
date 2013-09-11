require 'dune/contact'

module Dune
  class Storage
    def initialize
    end

    def authenticate_user(jid, password)
      true
    end

    def get_roster(jid)
      []
    end


    # Returns relevant contact
    def subscribe(jid, contact_jid)
    end
  end
end
