class Contained::Command::Login
  # @param stdin [IO]
  # @param stdout [IO]
  # @param argv [Array<String>]
  def initialize(stdin:, stdout:, argv:)
    @stdin = stdin
    @stdout = stdout
    @argv = argv
  end

  def execute!
    raise NotImplementedError, "#handle! undefined"
  end

  # @return [String]
  def username!
    @options.fetch(:username)
  end

  # @return [String]
  def password
    @options.fetch(:password)
  end
end
