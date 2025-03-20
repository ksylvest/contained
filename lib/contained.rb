# frozen_string_literal: true

require 'zeitwerk'
require 'optparse'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect "cli" => "CLI"
loader.setup

module Contained
  class Error < StandardError; end
  # Your code goes here...
end
