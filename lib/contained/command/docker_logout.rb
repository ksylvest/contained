# frozen_string_literal: true

module Contained
  module Command
    # User to `docker login` to a registry using a provided username and password.
    #
    # @example
    #   Contained::Task::Login.command(environment: "production", config: {
    #     registry: {
    #     server: "hub.docker.com",
    #   }) # => [:docker, :login, "hub.docker.com"]
    class DockerLogout < Base
      DEFAULT_SERVER = "hub.docker.com"

      # @return [Array<Symbol,String>]
      def command
        [
          :docker,
          :logout,
          server,
        ]
      end

    private

      # @return [String]
      def server
        @config.dig("registry", "server") || DEFAULT_SERVER
      end
    end
  end
end
