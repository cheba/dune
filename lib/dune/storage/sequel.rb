require 'sequel'

module Dune
  class SequelStorage < Storage
    def initialize(connection_params = nil)
      @db = Sequel.connect(connection_params)

      setup_schema
    end

    def authenticate_user(jid, password)
      !!@db[:users].where(jid: jid.bare, password: password).first
    end

    def get_roster(jid)
      @db[:contacts].where(jid: jid.bare).map do |contact|
        Contact.new(
          contact[:contact_jid],
          contact[:pending],
          contact[:subscription],
          contact[:name],
          contact[:groups] || []
        )
      end
    end

    def set_roster(jid, contact)
      puts "Setting contact: #{contact}"
      dset = @db[:contacts].where(jid: jid.bare, contact_jid: contact.jid.bare)
      if dset.first
        dset.update(contact.attributes.select {|k, v| [:name, :pending, :subscription, :gruops].include? k })
      else
        a = contact.attributes
        a[:contact_jid] = a[:jid]
        a[:jid] = jid.bare

        dset.insert(a)
      end

      data = dset.first
      Contact.new(
        data[:contact_jid],
        data[:pending],
        data[:subscription],
        data[:name],
        data[:groups] || []
      )
    end

    private

    def setup_schema
      @db.create_table? :users do
        String :jid, primary_key: true, unique: true, null: false
        String :password
      end

      @db.create_table? :contacts do
        String :jid, null: false
        String :contact_jid, null: false
        String :name
        String :groups, text: true
        TrueClass :pending, default: true
        String :subscription, default: 'none'
        primary_key [:jid, :contact_jid]
      end
    end
  end
end
