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

        on servers, in: :sequence do |host|
          puts("[starting] host=#{host.hostname}")
          within "~/.contained/#{stack}" do
            execute("source .env")
            execute("docker stack deploy -c ./compose.yml #{stack} --with-registry-auth")
          end
          puts("[done] host=#{host.hostname}")
        end
      end
    end
  end
end
