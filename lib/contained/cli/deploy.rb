# frozen_string_literal: true

module Contained
  class CLI
    # @example
    #   Contained::CLI::Deploy.handle!(stdout: $stdout, stderr: $stderr, argv: %i[--environment demo])
    class Deploy < Contained::CLI::Base
      def handle!
        arguments = arguments!

        config = Contained::Config.load_file(path: arguments.fetch(:config))
        environment = arguments.fetch(:environment)

        Contained::Task::Deploy.execute!(stdin: @stdin, stdout: @stdout, environment:, config:)
      end

    private

      # @return [Hash]
      def arguments!
        { config: "./config/deploy.yml", environment: "default" }.tap do |arguments|
          parser(into: arguments).parse!
        end
      end

      # @param into [Hash]
      # @return [OptionParser]
      def parser(into:)
        OptionParser.new do |options|
          options.banner = "usage: contained deploy [options] "

          options.on("-h", "--help", "help") do
            @stdout.puts(options)
            exit
          end

          options.on("-c", "--config=CONFIG", "config") do |config|
            into[:config] = config
          end
          options.on("-e", "--environment=ENVIRONMENT", "environment") do |environment|
            into[:environment] = environment
          end
        end
      end
    end
  end
end
