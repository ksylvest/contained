# frozen_string_literal: true

module Contained
  module Command
    # User to `docker login` to a registry using a provided username and password.
    #
    # @example
    #   Contained::Task::Login.command(environment: "production", config: {
    #     registry: {
    #     server: "hub.docker.com",
    #     username: "root",
    #     password: "secret",
    #   }) # => [:docker, :login, "hub.docker.com", "-u", "root", "-p", "secret"]
    class DockerLogin < Base
      DEFAULT_SERVER = "hub.docker.com"

      # @return [Array<Symbol,String>]
      def command
        [
          :docker,
          :login,
          server,
          "-u", username,
          "-p", password,
        ]
      end

    private

      # @return [String, nil]
      def username
        @config.dig("registry", "username")
      end

      # @return [String, nil]
      def password
        @config.dig("registry", "password")
      end

      # @return [String]
      def server
        @config.dig("registry", "server") || DEFAULT_SERVER
      end
    end
  end
end
