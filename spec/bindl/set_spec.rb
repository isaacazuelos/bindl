require 'bindl/set'

describe Bindl::Set do
  describe '.set' do
    let(:set) { Bindl::Set }
    let(:data) do
      {
        'key1' => 'val1',
        'key2' => { 'key3' => 'val2' },
        'key4' => [0, 'yay', 2]
      }
    end
    it 'should set for simple keys' do
      expect(set.set(data, 'key0', 'foo')).to include('key0' => 'foo')
    end
    it 'should set for nested keys' do
      expected = { 'key2' => { 'key5' => 'foo', 'key3' => 'val2' } }
      expect(set.set(data, 'key2.key5', 'foo')).to include expected
    end
    it 'should overwrite existing values' do
      expected = { 'key1' => 'updated' }
      expect(set.set(data, 'key1', 'updated')).to include expected
    end
    it 'should set inside arrays' do
      expect(set.set([0, 'boo', 2], '1', 'yay')).to eq [0, 'yay', 2]
    end
    it 'should be able to push to the end of arrays' do
      expect(set.set([0], '1', 'boo')).to eq [0, 'boo']
    end
    it 'should create nested hashs as needed' do
      expected = { 'key6' => { 'key7' => { 'key8' => 'nested' } } }
      expect(set.set(data, 'key6.key7.key8', 'nested')).to include(expected)
    end
    it 'should be able to set compound values' do
      expect(set.set({}, ':a', b: 1)).to eq(a: { b: 1 })
    end
    it 'should create arrays as needed' do
      expect(set.set([], '0.0.0', 'nested')).to eq [[['nested']]]
    end
    it 'should not overwrite existing hashs when `preserve` is set' do
      expect do
        set.set(data, 'key1', 'nope', true)
      end.to raise_error Bindl::Set::InsertError
    end
    it 'should not overwrite existing values when `preserve` is set' do
      expect do
        set.set(data, 'key1.key2', 'nope', true)
      end.to raise_error Bindl::Set::InsertError
    end
    it 'should raise when inserting past array.count' do
      expect do
        set.set([], '3', 'nope')
      end.to raise_error Bindl::Set::InsertError
    end
    it 'should raise `Keep::InvalidInsertion` creating indices past 0' do
      expect do
        set.set([], '0.1', 'nope')
      end.to raise_error Bindl::Set::InsertError
    end
  end
end
