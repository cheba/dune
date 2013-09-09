require 'dune/parser'
require 'dune/errors'
require 'celluloid/io/ssl_socket'

module Dune
  class Stream
    MAX_AUTH_FAILS = 3

    attr_accessor :id, :domain, :server, :user

    def initialize(socket, server)
      @socket = socket
      @server = server
      @closed = false
      @auth_fails = 0

      @id = ''
      @domain = nil
      @user = nil

      @parser = Parser.new(self)

      @stanza_size = 0
    end

    def run
      loop do
        return if @closed

        data = @socket.readpartial(4096)
        puts "\e[33m#{data.strip.empty? ? '∅' : data}\e[0m"
        @parser << data
      end
    rescue EOFError => e
      puts e
      close
    ensure
      @socket.close
      puts "I'm done"
    end

    def write(str)
      if str
        str = str.to_xml if str.respond_to?(:to_xml)

        puts "\e[36m#{str.strip.empty? ? '∅' : str}\e[0m"
        @socket.write(str).tap do |n|
          puts "<-   #{n}"
        end
      end
    end

    def close
      puts 'closing stream'
      @closed = true
      write('</stream:stream>')
    end

    def secure?
      @socket.is_a? Celluloid::IO::SSLSocket
    end

    def authenticated?
      !@user.nil?
    end

    def bound?
      authenticated? && !user.jid.resource.empty?
    end

    def start_tls
      unless secure?
        ssl_context = OpenSSL::SSL::SSLContext.new.tap do |context|
          context.ca_file = server.config.client.ca_file
          context.cert = OpenSSL::X509::Certificate.new(File.read(server.config.client.cert))
          context.key = OpenSSL::PKey::RSA.new(File.read(server.config.client.key))
        end

        raw_socket = @socket
        write '<proceed xmlns="urn:ietf:params:xml:ns:xmpp-tls"/>'
        begin
          @socket = Celluloid::IO::SSLSocket.new(raw_socket, ssl_context)
          @socket.accept
        rescue OpenSSL::SSL::SSLError
          @socket.close
        else
          restart
        end

        true
      else
        false
      end
    end

    def restart
      puts "Restarting stream"
      @parser = Parser.new(self)
      @auth_fails = 0
    end

    def error(e)
      case e
      when SaslError, StanzaError
        write e
      when StreamError
        write e
        close
      else
        puts "\e[31mError: #{e}\e[0m"
        write StreamErrors::InternalServerError.new
        close
      end
    end

    def bind(resource)
      if resource.empty?
        resource = SecureRandom.uuid
      end

      jid = JID.new(user.jid.identifier, user.jid.domain, resource)

      if @server.router.stream_for jid
        resource << SecureRandom.uuid
      end

      user.jid.resource = resource
    end

    def auth_fail(e)
      @auth_fails += 1
      if @auth_fails >= MAX_AUTH_FAILS
        error StreamErrors::PolicyViolation.new("max authentication attempts exceeded")
      else
        error e
      end
    end
  end
end
