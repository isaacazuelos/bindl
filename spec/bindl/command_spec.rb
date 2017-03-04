describe Bindl::Subcommand do
  class Bindl::Subcommand::TestCommand < Bindl::Subcommand::BaseCommand; end
  describe 'command setup' do
    it 'should have the right name' do
      expect(Bindl::Subcommand::TestCommand.new.name).to eq 'testcommand'
    end
    it 'should be in Command.commands' do
      expect(Bindl::Subcommand.commands.map(&:name)).to include 'testcommand'
    end
  end
end
