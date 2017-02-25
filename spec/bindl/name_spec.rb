describe Bindl::Name do
  describe '.from_path' do
    it 'should work for basic examples' do
      expect(Bindl::Name.from_path('/some/path/to/entry.ext', '/some/path'))
        .to(eq('to/entry'))
    end
    it 'should allow hidden directories' do
      expect(Bindl::Name.from_path('/hidden/.path/entry.ext', '/hidden'))
        .to(eq('.path/entry'))
      expect(Bindl::Name.from_path('/hidden/.path/entry.ext', '/hidden/.path'))
        .to(eq('entry'))
    end
    it 'should allow hidden files' do
      expect(Bindl::Name.from_path('/hidden/.entry.yml', '/hidden'))
        .to(eq('.entry'))
    end
    it 'should disallow directories' do
      expect do
        Bindl::Name.from_path('/dir/after/dir/', '/dir/')
      end.to raise_error Bindl::Name::InvalidNameError
    end
    it 'should remove all extensions' do
      expect(Bindl::Name.from_path('/dir/entry.ext1.ext2', '/dir'))
        .to(eq('entry'))
    end
  end

  describe '.validate!' do
    it 'should work for basic names' do
      expect(Bindl::Name.validate!('basic-name')).to eq('basic-name')
    end
    it 'should allow path seperators' do
      expect(Bindl::Name.validate!('path/sep')).to eq('path/sep')
    end
    it 'should not allow ending in path seperators' do
      expect do
        Bindl::Name.validate!('path/sep/')
      end.to raise_error Bindl::Name::InvalidNameError
    end
    it 'should allow hidden files and directories' do
      expect(Bindl::Name.validate!('hidden/.name')).to eq('hidden/.name')
      expect(Bindl::Name.validate!('.hidden/name')).to eq('.hidden/name')
    end
    it 'should not allow the files to extensions' do
      expect do
        Bindl::Name.validate!('has/extensions.yup')
      end.to raise_error Bindl::Name::InvalidNameError
    end
  end
end
