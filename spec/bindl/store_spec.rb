require 'fileutils'

describe Bindl::Store do
  include FakeFS::SpecHelpers
  before(:each) do
    path = '/dir/store/'
    @store = Bindl::Store.new(path)
    FileUtils.mkdir_p path
    entry = File.join(path, 'entry.ext')
    FileUtils.touch entry
  end
  describe '.initalize' do
    it 'should ensure root is saved as an absolute path' do
      store = Bindl::Store.new('rel-root')
      expect(store.root).to(eq(File.absolute_path('rel-root')))
    end
    it 'should default to the default' do
      store = Bindl::Store.new
      expect(store.root).to eq File.absolute_path Bindl::STORE_DIR
    end
  end
  describe '#exist?' do
    it 'should be true if the store dir exists' do
      expect(Bindl::Store.new('/').exist?).to be true
    end
    it 'should be false if it does not exist' do
      expect(Bindl::Store.new('/dev/null/nope').exist?).to be false
    end
  end
  describe '.create!' do
    it 'should create the store\'s directory' do
      store = Bindl::Store.new('/test/store/')
      expect(store.exist?).to be false
      expect(store.create!)
      expect(store.exist?).to be true
    end
  end
  describe '#each' do
    it 'should be empty? if the store does not exist?' do
      expect(Bindl::Store.new('/dne/store').each.empty?).to be true
    end
    it 'should enumerate the file paths in the store' do
      expect(@store.each).to eq ['/dir/store/entry.ext']
    end
    it 'should include files in nested directories' do
      FileUtils.mkdir_p '/dir/store/nested/'
      FileUtils.touch '/dir/store/nested/entry2.ext'
      expect(@store.each).to match_array ['/dir/store/entry.ext',
                                          '/dir/store/nested/entry2.ext']
    end
    it 'should give absolute paths' do
      res = @store.each.first
      expect(res).to_not eq nil
      expect(res).to eq File.absolute_path(res)
    end
    it 'should include hidden files iff :hidden is true' do
      FileUtils.touch '/dir/store/.hidden.ext'
      expect(@store.each).to eq ['/dir/store/entry.ext']
      expect(@store.each(hidden: true))
        .to match_array ['/dir/store/entry.ext', '/dir/store/.hidden.ext']
    end
    it 'should include hidden directories iff :hidden is true' do
      FileUtils.mkdir_p '/dir/store/.hidden/'
      FileUtils.touch   '/dir/store/.hidden/secret.ext'
      expect(@store.each).to eq ['/dir/store/entry.ext']
      expect(@store.each(hidden: true))
        .to match_array ['/dir/store/entry.ext',
                         '/dir/store/.hidden/secret.ext']
    end
    it 'should not include directories' do
      FileUtils.mkdir '/dir/store/empty-dir'
      expect(@store.each).to eq ['/dir/store/entry.ext']
    end
    it 'should ignore files which would be invalid names' do
      FileUtils.touch '/dir/store/invalid.name.'
      expect(@store.each).to eq ['/dir/store/entry.ext']
    end
  end
  describe '#include?' do
    it 'should be nil if the store does not exist?' do
      store = Bindl::Store.new('/dne/test/store/')
      expect(store.exist?).to be false
      expect(store.include?('anything')).to be nil
    end
    it 'should return true iff the name has a file in the store' do
      expect(@store.exist?).to be true
      expect(@store.include?('dne')).to be false
      expect(@store.include?('entry')).to be true
    end
  end
  describe '#[]' do
    it 'should be nil if the store does not exist?' do
      store = Bindl::Store.new('/dne/test/store/')
      expect(store.exist?).to be false
      expect(store['anything']).to eq nil
    end
    it 'should be false if the store does not include? the name' do
      expect(@store.exist?)
      expect(@store['dne']).to eq nil
    end
    it 'should be the entry if the store include? the name' do
      expect(@store.exist?)
      expect(@store['entry']).to be_a Bindl::Entry
    end
  end
  describe '#add' do
    it 'should raise if the store does not exist' do
      store = Bindl::Store.new('/dne/')
      expect do
        store.add('nope')
      end.to raise_error Bindl::Store::StoreDoesNotExistError
    end
    it 'should raise if the entry exists' do
      FileUtils.mkdir_p '/dir/store/'
      FileUtils.touch   '/dir/store/entry.yml'
      expect do
        @store.add('entry')
      end.to raise_error Bindl::Entry::EntryExistsError
    end
    it 'should create an entry with the name' do
      @store.add('entry')
      expect(@store.each).to include('/dir/store/entry.yml')
    end
  end
end
