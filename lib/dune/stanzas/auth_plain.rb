require 'dune/errors'
require 'dune/jid'
require 'dune/user'
require 'base64'

module Dune
  module Stanzas
    class AuthPlain < Stanza

      matcher(-> n {
        n.name == 'auth' && n[:mechanism] == 'PLAIN'
      })

      def response
        if @stream.authenticated?
        else
          payload = @element.text
          if payload.empty?
            @stream.auth_fail SaslErrors::MalformedRequest.new
            nil
          else
            auth
          end
        end
      end

      private

      def auth
        # http://tools.ietf.org/html/rfc6120#section-6.3.8
        # http://tools.ietf.org/html/rfc4616
        authzid, identifier, password = decode64(@element.text).split("\x00")

        if identifier.nil? || identifier.empty? || password.nil? || password.empty?
          @stream.auth_fail(SaslErrors::NotAuthorized.new)
          nil
        else
          jid = JID.new(identifier, @stream.domain)

          if jid.valid?
            user = User.authenticate(jid, password, @stream.server)
            puts user.inspect
            if user
              # TODO implement authorization
              # authzid denotes an entity on whose behalf authenticating entity
              # acts.

              @stream.user = user
              %Q{<success xmlns="#{NAMESPACES[:sasl]}"/>}
            else
              @stream.auth_fail(SaslErrors::NotAuthorized.new)
              nil
            end
          else
            @stream.auth_fail(SaslErrors::NotAuthorized.new)
            nil
          end
        end
      rescue => e
        @stream.auth_fail(e)
        raise
        nil
      end

      # Decode the base64 encoded string, raising an error for invalid data.
      # http://tools.ietf.org/html/rfc6120#section-13.9.1
      def decode64(encoded)
        Base64.strict_decode64(encoded)
      rescue StandardError => e
        puts e
        raise SaslErrors::IncorrectEncoding
      end
    end
  end
end
