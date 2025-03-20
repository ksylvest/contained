# frozen_string_literal: true

module Contained
  module Task
    # @example
    #   Contained::Task::Setup.execute(environment: "production", config: {})
    class Setup < Base
      def execute!
        stack = @config.fetch("stack")
        username = ENV["DOCKER_LOGIN"]
        password = ENV["DOCKER_PASSWORD"]

        deploy_compose_yml = File.open("./config/deploy/compose.yml")
        deploy_env = File.open("./config/deploy/.env.#{@environment}")

        @stdout.puts("[setup] stack=#{stack} environment=#{@environment}")

        on hosts, in: :sequence do
          execute(:docker, :login, "-u", username, "-p", password) if username && password

          execute(:docker, :swarm, :init) unless capture(:docker, :info).include?("Swarm: active")

          execute("mkdir -p ./.contained/#{stack}")

          upload!(deploy_compose_yml, "./.contained/#{stack}/compose.yml")
          upload!(deploy_env, "./.contained/#{stack}/.env")

          execute(<<~BASH)
            source ./.contained/#{stack}/.env
            docker stack deploy -c ./.contained/#{stack}/compose.yml #{stack} --with-registry-auth
          BASH
        end
      end
    end
  end
end
