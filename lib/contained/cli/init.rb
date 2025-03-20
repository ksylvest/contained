# frozen_string_literal: true

module Contained
  class CLI
    # @example
    #   Contained::CLI::Init.handle!(stdout: $stdout, stderr: $stderr, argv: %i[--image example/app --stack app])
    class Init < Base
      Arguments = Data.define(:image, :stack)

      TEMPLATE = <<~YAML
        stack: example

        registry:
          server: hub.docker.com
          username:
            - DOCKER_REGISTRY_TOKEN
          password:
            - DOCKER_REGISTRY_TOKEN

        environments:
          production:
            servers:
              - 1.2.3.4
              - 5.6.7.8
          test:
            servers:
              - 4.3.2.1
              - 8.7.6.5

        config:
          services:
            app:
              image: example/app
              ports:
                - "80:80"
              healthcheck:
                test: ["CMD", "curl", "-f", "http://localhost/up"]
                interval: 30s
                timeout: 10s
                retries: 3
      YAML

      def handle!
        if File.exist?("./config/deploy.yml")
          @stdout.puts("overwrite 'config/deploy.yml' (yes/no)?")
          @stdin.gets { |response| return unless response.strip.eql?("yes") }
        end

        Dir.mkdir("./config") unless Dir.exist?("./config")
        File.write("./config/deploy.yml", TEMPLATE)

        @stdout.puts("setup 'config/deploy.yml'")
      end

    private

      # @return [Arguments]
      def arguments!
        Arguments.new(DEFAULT_IMAGE, DEFAULT_STACK).tap do |arguments|
          parser(into: arguments).parse!(@argv)
        end
      end

      # @param into [Arguments]
      # @return [OptionParser]
      def parser(into:)
        OptionParser.new do |options|
          options.banner = "usage: contained init [options]"

          options.on("-h", "--help", "help") do
            @stdout.puts(options)
            exit
          end
        end
      end
    end
  end
end
