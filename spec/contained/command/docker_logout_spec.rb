# frozen_string_literal: true

RSpec.describe Contained::Command::DockerLogout do
  subject(:command) { described_class.new(environment:, config:) }

  let(:environment) { "test" }
  let(:config) do
    {
      "registry" => {
        "server" => "hub.docker.com",
        "username" => "root",
        "password" => "secret",
      },
    }
  end

  describe "#args" do
    it "returns 'docker logout hub.docker.com" do
      expect(command.command).to eq(
        [
          :docker,
          :logout,
          "hub.docker.com",
        ]
      )
    end
  end
end
