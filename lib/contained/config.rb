# frozen_string_literal: true

require "yaml"

module Contained
  # @example
  #
  #  Contained::Config.load_file(path: "./config/deploy.yml")
  class Config
    # @param path [String]
    #
    # @return [Contained::Config]
    def self.load_file(path: "./config/deploy.yml")
      YAML.load_file(path)
    end

    # # @param data [Hash]

    # # @return [Contained::Config]
    # def self.parse!(data:)
    #   new(
    #     stack: data.fetch("stack"),
    #     registry: data.fetch("registry"),
    #     environments: data.fetch("environments"),
    #     config: data.fetch("config")
    #   )
    # end

    # # @!attribute [rw] stack
    # #   @return [String]
    # attr_accessor :stack

    # # @!attribute [rw] registry
    # #   @return [Hash]
    # attr_accessor :registry

    # # @!attribute [rw] environments
    # #   @return [Hash]
    # attr_accessor :environments

    # # @!attribute [rw] config
    # #   @return [Hash]
    # attr_accessor :config

    # # @param stack [String]
    # # @param registry [Hash]
    # # @param environments [Hash]
    # # @param config [Hash]
    # def initialize(stack:, registry:, environments:, config:)
    #   @stack = stack
    #   @registry = registry
    #   @environments = environments
    #   @config = config
    # end
  end
end
