require 'dune/contact'

module Dune
  class Storage
    def initalize
    end

    def authenticate_user(jid, password)
      true
    end

    def get_roster(jid)
      [Contact.new]
    end
  end
end
