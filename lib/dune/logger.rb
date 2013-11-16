require 'logger'
module Dune
  class Logger < ::Logger
    def initialize(logdev, shift_age = 0, shift_size = 1048576)
      super
      @default_formatter = Formatter.new
    end

    class Formatter < ::Logger::Formatter
      def call(severity, time, progname, msg)
        "#{severity.ljust 5, ' '} [#{format_datetime time}]#{" (#{progname})" unless progname.nil?}:\n" +
        msg2str(msg) + "\n\n"
      end

      private

      def format_datetime(time)
        if @datetime_format.nil?
          time.strftime("%Y-%m-%dT%H:%M:%S.") << "%06d" % time.usec
        else
          time.strftime(@datetime_format)
        end
      end
    end
  end
end
