require 'bindl/store'
require 'bindl/name'
require 'bindl/meta'

describe Bindl::Store do
  describe '#meta' do
    include FakeFS::SpecHelpers
    before(:each) { @store = Bindl::Store.new('/test-store/').create! }
    it 'should return an entry named Bindl::META_NAME' do
      expect(@store.meta.path)
        .to match(Bindl::META_NAME)
    end
    it 'should create the entry if needed' do
      expect(File.file?(@store.meta.path)).to eq true
    end
  end
end
