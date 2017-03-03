describe Bindl::Command do
  class Bindl::TestCommand < Bindl::Command; end
  describe 'command setup' do
    it 'should have the right name' do
      expect(Bindl::TestCommand.new.name).to eq 'testcommand'
    end
    it 'should be in Command.commands' do
      expect(Bindl::Command.commands.map(&:name)).to include 'testcommand'
    end
  end
end
