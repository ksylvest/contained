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
        username = ENV["DOCKER_LOGIN"]
        password = ENV["DOCKER_PASSWORD"]

        @stdout.puts("[deploy] stack=#{stack} environment=#{@environment}")

        on hosts, in: :sequence do
          execute(:docker, :login, "-u", username, "-p", password) if username && password
          execute(:docker, :system, :prune, "-f")

          execute(<<~BASH)
            source ./.contained/#{stack}/.env
            docker stack deploy -c ./.contained/#{stack}/compose.yml #{stack} --with-registry-auth
          BASH
        end
      end
    end
  end
end
