# frozen_string_literal: true

require "sshkit"

module Contained
  module Command
    # @abstract
    class Base
      include SSHKit::DSL

      def self.command(...)
        new(...).command
      end

      # @environment [String]
      # @config [Contained::Config]
      def initialize(environment:, config:)
        @environment = environment
        @config = config
      end

      # @return [Array<Symbol,String>] e.g. [:docker, :login, "hub.docker.com", "-u", "root", "-p", "secret"]
      def command
        raise NotImplementedError, "#execute! undefined"
      end

    protected

      # @return [Array<Hash<{ hostname: String }>>]
      def hosts
        @config.dig("environments", @environment, "hosts").map do |hostname|
          @config.fetch("ssh", {}).merge({ hostname: })
        end
      end
    end
  end
end
