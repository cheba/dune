require 'celluloid/io'
require 'openssl'
require 'dune/stream'
require 'dune/router'
require 'dune/storage'

module Dune
  class Server
    include Celluloid::IO

    attr_reader :router, :storage

    def initialize
      host = 'lvh.me'
      port = 5222
      puts("Accepting client connections on #{host}:#{port}")

      @router = Router.new
      @storage = Storage.new

      @server = TCPServer.new(host, port)

      #async.run
      run
    end

    def run
      #loop { async.handle_connection @server.accept }
      loop { handle_connection @server.accept }
    end

    private

    def handle_connection(socket)
      puts "new connection"
      stream = Dune::Stream.new(socket, self)
      @router << stream

      stream.run

      @router >> stream
    end
  end
end
