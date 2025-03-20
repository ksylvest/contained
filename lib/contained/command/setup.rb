# frozen_string_literal: true

module Contained
  module Command
    # @example
    #   Contained::Command::Setup.execute(environment: "production", config: {})
    class Setup < Base
      def execute!
        stack = @config.fetch("stack")

        deploy_compose_yml = File.open("./config/deploy/compose.yml")
        deploy_env = File.open("./config/deploy/.env.#{@environment}")

        @stdout.puts("[setup] stack=#{stack} environment=#{@environment} hosts=#{hosts}")

        on hosts, in: :sequence do |host|
          puts("[starting] host=#{host.hostname}")

          execute("mkdir -p ./.contained/#{stack}")

          upload!(deploy_compose_yml, "./.contained/#{stack}/compose.yml")
          upload!(deploy_env, "./.contained/#{stack}/.env")

          execute(<<~BASH)
            source ./.contained/#{stack}/.env
            docker stack deploy -c ./.contained/#{stack}/compose.yml #{stack} --with-registry-auth
          BASH

          puts("[done] host=#{host.hostname}")
        end
      end
    end
  end
end
