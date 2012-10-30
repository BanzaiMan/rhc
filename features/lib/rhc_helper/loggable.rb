require 'logger'

module RHCHelper
  module Loggable
    def logger
      Loggable.logger
    end

    def perf_logger
      Loggable.perf_logger
    end

    def self.logger
      @logger ||= Logger.new($stdout)
    end

    def self.logger=(logger)
      @logger = logger
      original_formatter = Logger::Formatter.new
      @logger.formatter = proc { |severity, datetime, progname, msg|
        begin
          # Filter out any passwords
          filter_msg = msg.gsub(PASSWORD_REGEX, " -p ***** ") 
        rescue ArgumentError # msg can contain invalid byte sequences
          filger_msg = 'Encountered problem filtering a message.'
        ensure
          # Format with the original formatter
          original_formatter.call(severity, datetime, progname, filter_msg)
        end
      }
    end

    def self.perf_logger
      @perf_logger ||= Logger.new($stdout)
    end

    def self.perf_logger=(logger)
      @perf_logger = logger
    end
  end
end
