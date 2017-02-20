describe Locket::Entry do
  include FakeFS::SpecHelpers
  before(:each) { @store = Locket::Store.new('/').create! }
  describe '.initialize' do
    it 'should demand that the store exist' do
      expect do
        Locket::Entry.new(Locket::Store.new('/dne/'), 'entry.ext')
      end.to raise_error Locket::Store::StoreDoesNotExistError
    end
    it 'should demand a path that produces a valid name' do
      FileUtils.touch 'invalid.'
      expect do
        Locket::Entry.new @store, 'invalid.'
      end.to raise_error Locket::Name::InvalidNameError
    end
    it 'should require that the file exists' do
      expect do
        Locket::Entry.new @store, 'dne.ext'
      end.to raise_error Locket::Entry::EntryDoesNotExistError
      FileUtils.touch 'exists.ext'
      expect do
        Locket::Entry.new @store, 'exists.ext'
      end.to_not raise_error
    end
  end
  describe '#path' do
    # This is just an attr_accessor, so no tests are really needed.
  end
  describe '.create!' do
    it 'should raise if the store does not exist' do
      expect do
        Locket::Entry.create! Locket::Store.new('/dne/'), 'entry'
      end.to raise_error Locket::Store::StoreDoesNotExistError
    end
    it 'should raise if the file exists' do
      path = '/entry.yml'
      FileUtils.touch path
      expect do
        Locket::Entry.create! @store, 'entry'
      end.to raise_error Locket::Entry::EntryExistsError
    end
    it 'should raise if the entry would have an invalid name' do
      path = '/entry.invalid.'
      FileUtils.touch path
      expect do
        Locket::Entry.create! @store, path
      end.to raise_error Locket::Name::InvalidNameError
    end
    it 'should create the file' do
      name = 'entry'
      expect do
        Locket::Entry.create! @store, name
      end.to_not raise_error
      expect(File.file?('/entry.yml')).to be true
    end
  end
  describe '#delete!' do
    it 'should delete the file' do
      path = '/entry.ext'
      FileUtils.touch path
      entry = Locket::Entry.new @store, path
      expect(File.file?(path)).to be true
      entry.delete!
      expect(File.file?(path)).to be false
    end
    it 'should set path to nil' do
      path = '/entry.ext'
      FileUtils.touch path
      entry = Locket::Entry.new @store, path
      expect(File.file?(path)).to be true
      entry.delete!
      expect(entry.path).to be nil
    end
  end
  describe 'data' do
    it 'should return the contents of the file' do
      path = '/entry.ext'
      data = 'this is a test string!'
      File.write(path, data)
      entry = Locket::Entry.new @store, path
      expect(entry.data).to eq data
    end
  end
  describe 'data=' do
    it 'should overwrite the file with the new data' do
      path = '/entry.ext'
      data = 'this is new data'
      File.write(path, 'old data')
      entry = Locket::Entry.new @store, path
      entry.data = data
      expect(File.read(path)).to eq data.to_yaml
    end
  end
end
