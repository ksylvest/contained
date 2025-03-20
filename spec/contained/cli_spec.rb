# frozen_string_literal: true

RSpec.describe Contained::CLI do
  subject(:cli) { described_class.new(stdin:, stdout:, argv:) }

  let(:stdin) { StringIO.new }
  let(:stdout) { StringIO.new }

  describe "#parse" do
    subject(:parse) { cli.parse }

    context "with an unknown command" do
      let(:argv) { ["unknown"] }

      it "raises an error" do
        expect { cli.parse }.to raise_error(Contained::Error, 'unsupported command="unknown"')
      end
    end

    context "with a deploy command" do
      let(:argv) { ["deploy"] }

      it "calls Contained::CLI::Deploy" do
        allow(Contained::CLI::Deploy).to receive(:handle!)
        parse
      expect(Contained::CLI::Deploy).to have_received(:handle!).with(stdin:, stdout:, argv:)
      end
    end

    %w[-v --version].each do |option|
      context "with a '#{option}' flag" do
        let(:argv) { [option] }

        it "prints version" do
          expect { parse }.to raise_error(SystemExit)
          expect(stdout.string).to eql("#{Contained::VERSION}\n")
        end
      end
    end

    %w[-h --help].each do |option|
      context "with a '#{option}' flag" do
        let(:argv) { [option] }

        it "prints help" do
          expect { parse }.to raise_error(SystemExit)
          expect(stdout.string).not_to be_empty
        end
      end
    end
  end
end
