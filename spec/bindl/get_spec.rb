require 'bindl/get'

describe Bindl::Get do
  let(:get) { Bindl::Get }
  describe 'self.get' do
    it 'should retreive from hashs' do
      data = { 'key1' => 'val1' }
      expect(get.get(data, 'key1')).to eq('val1')
    end
    it 'should retreive from arrays' do
      data = 'val1', 'val2'
      expect(get.get(data, '0')).to eq('val1')
    end
    it 'should retreive from nested structures' do
      data = { 'key1' => { 'key2' => [0, 'yay', 2] } }
      expect(get.get(data, 'key1.key2.1')).to eq('yay')
    end
    it 'should raise `KeyError` for out-of-bounds keys' do
      expect do
        get.get([], '0')
      end.to raise_error KeyError
    end
    it 'should raise KeyError for missing keys' do
      expect do
        get.get({}, 'key1')
      end.to raise_error KeyError
    end
  end
end
