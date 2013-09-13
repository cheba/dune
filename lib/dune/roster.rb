module Dune
  class Roster
    def initialize(user)
      @user = user
    end

    def all
      @contacts ||= @user.server.storage.get_roster(@user.jid)
    end

    def <<(contact)
      contact = contact.dup
      existing_contact = self[contact.jid]

      unless @contacts.include? contact
        contact = @user.server.storage.set_roster(@user.jid, contact)
      end

      if existing_contact
        @contacts[@contacts.index(existing_contact)] = contact
      else
        @contacts << contact
      end

      contact
    end

    def subscribe(jid)
      contact = Contact.new(jid)

      unless self[jid]
        self << contact
      else
        self[jid]
      end
    end

    def [](jid)
      jid = JID.new(jid)
      @contacts.find { |c| c.jid.bare == jid.bare }
    end
  end
end
