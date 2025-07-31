# frozen_string_literal: true

require "fileutils"

module Contained
  class CLI
    # @example
    #   Contained::CLI::Init.handle!(stdout: $stdout, stderr: $stderr, argv: %i[--image example/app --stack app])
    class Init < Base
      Arguments = Data.define(:image, :stack)

      CONFIG_DEPLOY_COMPOSE_YML = <<~YAML
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

      CONFIG_DEPLOY_YML = <<~YAML
        stack: example

        registry:
          server: hub.docker.com
          username:
            - DOCKER_REGISTRY_TOKEN
          password:
            - DOCKER_REGISTRY_TOKEN

        environments:
          production:
            hosts:
              - 1.2.3.4
              - 5.6.7.8
          test:
            hosts:
              - 4.3.2.1
              - 8.7.6.5
      YAML

      def handle!
        arguments = arguments!
        path = arguments.fetch(:path)

        setup_config_dir(path:)
        setup_config_deploy_yml(path:)
        setup_config_deploy_compose_yml(path:)
      end

    private

      def setup_config_dir(path:)
        FileUtils.mkdir_p("#{path}/config/deploy")
      end

      def setup_config_deploy_yml(path:)
        if File.exist?("#{path}/config/deploy.yml")
          @stdout.puts("overwrite '#{path}/config/deploy.yml' (yes/no)?")
          response = @stdin.gets
          return unless response.strip.eql?("yes")
        end

        File.write("#{path}/config/deploy.yml", CONFIG_DEPLOY_YML)
        @stdout.puts("setup '#{path}/config/deploy.yml'")
      end

      def setup_config_deploy_compose_yml(path:)
        if File.exist?("#{path}/config/deploy/compose.yml")
          @stdout.puts("overwrite '#{path}/config/deploy/compose.yml' (yes/no)?")
          response = @stdin.get
          return unless response.strip.eql?("yes")
        end

        File.write("#{path}/config/deploy/compose.yml", CONFIG_DEPLOY_COMPOSE_YML)
        @stdout.puts("setup '#{path}/config/deploy/compose.yml'")
      end

      # @return [Arguments]
      def arguments!
        { path: "." }.tap do |arguments|
          parser(into: arguments).parse!(@argv)
        end
      end

      # @param into [Arguments]
      # @return [OptionParser]
      def parser(into:)
        OptionParser.new do |options|
          options.banner = "usage: contained init [options]"

          options.on("-p", "--path=PATH", "path") do |path|
            into[:path] = path
          end

          options.on("-h", "--help", "help") do
            @stdout.puts(options)
            exit
          end
        end
      end
    end
  end
end
