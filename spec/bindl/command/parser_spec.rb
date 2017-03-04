require 'bindl/subcommand/parser'

describe Bindl::Subcommand::Parser do
  let(:parser) { Bindl::Subcommand::Parser }
  describe '.options' do
    it 'should parse the options' do
      opts = [{ long: :test, short: 't' }]
      # expect(parser.options(['--test'], [], opts))
      # .to include(test: true)
    end
    it 'should automatically handle --help and --version' do
      expect do
        parser.options(['-h'], ['test-banner'], [])
      end.to raise_error(SystemExit).and output(/test-banner/).to_stdout
      expect do
        parser.options(['-v'], [], [])
      end.to raise_error(SystemExit).and output(/\./).to_stderr
    end
    it 'should raise on unexpected options' do
      expect do
        parser.options(['--not-real'], [], [])
      end.to raise_error(SystemExit).and output(/unknown/).to_stderr
    end
  end
  describe '.positional' do
    it 'should add positional arguments' do
      expect(parser.positional([1, 2, 3], [:a, :b, :c]))
        .to eq(a: 1, b: 2, c: 3)
    end
    it 'should raise if there are missing positional arguments' do
      expect do
        parser.positional([], [:expected])
      end.to raise_error Bindl::Subcommand::Parser::ParserError
    end
    it 'should raise if there are extra positional arguments' do
      expect do
        parser.positional([:extra], [])
      end.to raise_error Bindl::Subcommand::Parser::ParserError
    end
  end
  describe 'usage' do
    it 'should work for simple examples' do
      expect(parser.usage('test')).to eq 'Usage: bindl test'
    end
    it 'should add positional arguments as <arg>' do
      expect(parser.usage('test', [:pos1, :pos2]))
        .to eq 'Usage: bindl test <pos1> <pos2>'
    end
    it 'should add flags as [-f|--flag]' do
      expect(parser.usage('test', [], [{ short: 'f', long: 'flag' }]))
        .to eq 'Usage: bindl test [-f|--flag]'
    end
    it 'should work altogether' do
      expect(parser.usage('get', [:name, :keypath], [{ long: 'clip', short: 'c' }]))
        .to eq 'Usage: bindl get <name> <keypath> [-c|--clip]'
    end
  end
end
