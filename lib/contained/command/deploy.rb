# frozen_string_literal: true

# .contained/itva/compose.yml
# .contained/itva/.env
module Contained
  module Command
    # @example
    #   Contained::Command::Deploy.execute(environment: "production", config: {})
    class Deploy < Base
      def execute!
        stack = @config.fetch("stack")

        @stdout.puts("[deploying] stack=#{stack} environment=#{@environment}")

        on hosts, in: :sequence do |host|
          puts("[starting] host=#{host.hostname}")
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
