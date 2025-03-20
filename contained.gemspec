# frozen_string_literal: true

require_relative "lib/contained/version"

Gem::Specification.new do |spec|
  spec.name = "contained"
  spec.version = Contained::VERSION
  spec.authors = ["Kevin Sylvestre"]
  spec.email = ["kevin@ksylvest.com"]

  spec.summary = "Docker / Swarm / SSH"
  spec.description = "Makes releasing docker based containers via SSH using swarm a breeze"
  spec.homepage = "https://github.com/ksylvest/contained"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ksylvest/contained"
  spec.metadata["changelog_uri"] = "https://github.com/ksylvest/contained"

  spec.files = Dir.glob("{bin,lib,exe}/**/*") + %w[README.md Gemfile]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
