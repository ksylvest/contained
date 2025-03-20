# frozen_string_literal: true

RSpec.describe Contained::Task::DockerLogin do
  subject(:command) { described_class.new(environment: "production", config: config) }

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
    it "returns 'docker login hub.docker.com -u root -p secret'" do
      expect(command.command).to eq(
        [
          :docker,
          :login,
          "hub.docker.com",
          "-u", "root",
          "-p", "secret",
        ]
      )
    end
  end
end
