# frozen_string_literal: true

module Contained
  class CLI
    # @abstract
    class Base
      # @param stdin [IO]
      # @param stdout [IO]
      # @param argv [Array<String>]
      def self.handle!(stdin:, stdout:, argv:)
        new(stdin:, stdout:, argv:).handle!
      end

      # @param stdin [IO]
      # @param stdout [IO]
      # @param argv [Array<String>]
      def initialize(stdin:, stdout:, argv:)
        @stdin = stdin
        @stdout = stdout
        @argv = argv
      end

      def handle!
        raise NotImplementedError, "#handle! undefined"
      end
    end
  end
end
