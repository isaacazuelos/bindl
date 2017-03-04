describe Bindl::App do
  class Bindl::Subcommand::TestCommand < Bindl::Subcommand::BaseCommand
    def description
      'some-test'
    end

    def run(_options)
      throw :run_was_called
    end
  end
  describe '.command_list' do
    it 'should have the names of commands in it' do
      expect(Bindl::App.command_list)
        .to(match(Bindl::Subcommand::TestCommand.new.name))
    end
    it 'should have the descriptions too' do
      expect(Bindl::App.command_list).to match 'some-test'
    end
  end
  # This is moslty just testing that Trollop is being used, and is a
  # bad test.
  describe '.parse_args' do
    it 'should detect a --help flag' do
      expect(Bindl::App.parse_args([])).to include help: false
    end
    it 'should detect a --version flag' do
      expect(Bindl::App.parse_args([])).to include version: false
    end
  end
  describe '.run' do
    # Again, I don't much know how to test this...
    it 'should call the run for the command used' do
      expect do
        Bindl::App.run(['testcommand'])
      end.to throw_symbol :run_was_called
    end
  end
end
