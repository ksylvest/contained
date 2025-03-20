# frozen_string_literal: true

require "optparse"

module Contained
  # @example
  #
  #   cli = Contained::CLI.new
  #   cli.parse
  class CLI
    # @param input [IO]
    # @param output [IO]
    # @param argv [Array<String>] the arguments (e.g. ['deploy', '--help'])
    def initialize(stdin: $stdin, stdout: $stdout, argv: ARGV)
      @stdin = stdin
      @stdout = stdout
      @argv = argv
    end

    def parse
      parser.order!(@argv)
      command = @argv.shift
      return if command.nil?

      handler =
        case command
        when "init" then ::Contained::CLI::Init
        when "setup" then ::Contained::CLI::Setup
        when "deploy" then ::Contained::CLI::Deploy
        else raise ::Contained::Error, "unsupported command=#{command.inspect}"
        end

      handler.handle!(stdin: @stdin, stdout: @stdout, argv: @argv)
    end

    private

    # @return [OptionParser]
    def parser
      @parser ||= OptionParser.new do |options|
        options.banner = "usage: contained [options] <command> [<args>]"

        options.on("-h", "--help", "help") do
          @stdout.puts(options)
          exit
        end

        options.on("-v", "--version", "version") do
          @stdout.puts(Contained::VERSION)
          exit
        end

        options.separator <<~COMMANDS
          commands:
            init
            setup
            deploy
        COMMANDS
      end
    end
  end
end
