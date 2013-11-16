module Dune
  class Configuration
    def initialize(config_path = './dune.rb')
      @config_path = File.expand_path(config_path)
      unless File.exists? @config_path
        raise "Configuration file not found: #{@config_path}"
      end

      reload!
    end

    def reload!
      @client = nil
      @storage = nil

      config_content = File.read(@config_path)
      instance_eval config_content, @config_path

      if @storage.nil?
        raise "Starge driver is not defined"
      end
    end


    # Configuration DSL

    def client(&block)
      if block_given?
        @client = ClientConfiguration.new

        @client.instance_exec(&block)
      end
      @client
    end

    def storage(driver = nil, connection_params = nil)
      if driver
        @storage = StorageConfiguration.new(driver, connection_params)
      else
        @storage
      end
    end
  end

  class ClientConfiguration
    def initialize
      @host = nil
      @port = nil
      @cert = nil
      @key = nil
      @ca_file = nil
    end

    def host(host = nil)
      if host
        @host = host
      else
        @host
      end
    end

    def port(port = nil)
      if port
        @port = port
      else
        @port
      end
    end

    def cert(cert = nil)
      if cert
        @cert = File.expand_path(cert)

        unless File.exists? @cert
          raise "Certificate file not found: #{@cert}"
        end
      else
        @cert
      end
    end

    def key(key = nil)
      if key
        @key = File.expand_path(key)
        unless File.exists? @key
          raise "Certificate private key file not found: #{@key}"
        end
      else
        @key
      end
    end

    def ca_file(ca_file = nil)
      if ca_file
        @ca_file = File.expand_path(ca_file)
        unless File.exists? @ca_file
          raise "Certificate bundle file not found: #{@ca_file}"
        end
      else
        @ca_file
      end
    end
  end

  class StorageConfiguration
    def initialize(driver, connection_params = nil)
      driver_class_name = "#{driver.to_s.gsub(/((\A|_)([a-z]))/) {|c|c[-1].upcase }}Storage".to_sym
      if Dune.constants.include? driver_class_name
        @driver = Dune.const_get(driver_class_name)
        @connection_params = connection_params
      else
        raise "Driver #{driver} not found"
      end
    end

    attr_reader :driver, :connection_params
  end
end
