require 'sequel'
require 'yaml'

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
      @db[:contacts].where(jid: jid.bare).map do |c|
        puts c.inspect
        Contact.new(
          c[:contact_jid],
          c[:pending],
          c[:subscription],
          c[:name],
          c[:groups].nil? ? nil : YAML.parse(c[:groups])
        )
      end
    end

    def subscribe(jid, contact_jid)
      contact = @db[:contacts].where(jid: jid.bare, contact_jid: contact_jid.bare).first
      unless contact
        @db[:contacts].insert(jid: jid.bare, contact_jid: contact_jid.bare)
        contact = @db[:contacts].where(jid: jid.bare, contact_jid: contact_jid.bare).first
      end

      Contact.new(
        contact[:contact_jid],
        contact[:pending],
        contact[:subscription],
        contact[:name],
        contact[:groups].nil? ? nil : YAML.parse(contact[:groups])
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
