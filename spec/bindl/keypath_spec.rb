require 'bindl/keypath'

describe Bindl::Keypath do
  let(:kp) { Bindl::Keypath }
  describe '.parse' do
    it 'should work for simple keys' do
      expect(kp.parse('simple')).to eq(['simple'])
    end
    it 'should seperate segments by "."' do
      expect(kp.parse('simple.segments')).to eq(%w(simple segments))
    end
    it 'should parse numbers out of segments' do
      expect(kp.parse('1.2')).to eq([1, 2])
    end
    it 'should parse "true" and "false" as booleans' do
      expect(kp.parse('true')).to eq([true])
      expect(kp.parse('false')).to eq([false])
    end
    it 'should parse nil out of segments' do
      expect(kp.parse('null')).to eq([nil])
    end
    it 'should parse strings out of segments' do
      expect(kp.parse('these.are.strings')).to eq(%w(these are strings))
    end
    it 'should disallow collections as keys' do
      expect do
        kp.parse '[1]'
      end.to raise_error KeyError
      expect do
        kp.parse '{0:true}'
      end
    end
    it 'should disallow whitespace in keys' do
      expect do
        kp.parse ' '
      end.to raise_error KeyError
    end
  end
end
