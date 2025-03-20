# frozen_string_literal: true

# .contained/itva/compose.yml
# .contained/itva/.env
module Contained
  module Task
    # @example
    #   Contained::Task::Deploy.execute(environment: "production", config: {})
    class Deploy < Base
      def execute!
        stack = @config.fetch("stack")
        registry = @config.fetch("registry", { "server" => "hub.docker.com" })
        username = ENV["DOCKER_LOGIN"]
        password = ENV["DOCKER_PASSWORD"]

        @stdout.puts("[deploy] stack=#{stack} environment=#{@environment}")

        on hosts, in: :sequence do
          if username && password
            execute(:docker, :login, registry.fetch("server", "hub.docker.com"), "-u", username, "-p", password)
          end

          execute(<<~BASH)
            source ./.contained/#{stack}/.env
            docker stack deploy -c ./.contained/#{stack}/compose.yml #{stack} --with-registry-auth
          BASH
        end
      end
    end
  end
end
