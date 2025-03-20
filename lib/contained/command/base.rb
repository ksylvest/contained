# frozen_string_literal: true

require "sshkit"

module Contained
  module Command
    # @abstract
    class Base
      include SSHKit::DSL

      def self.execute!(...)
        new(...).execute!
      end

      # @param stdin [IO]
      # @param stdout [IO]
      # @environment [String]
      # @config [Contained::Config]
      def initialize(stdin:, stdout:, environment:, config:)
        @stdin = stdin
        @stdout = stdout
        @environment = environment
        @config = config
      end

      def execute!
        raise NotImplementedError, "#execute! undefined"
      end

    protected

      def servers
        @config.dig("environments", @environment, "servers")
      end
    end
  end
end
