require 'bindl/encrypt'

describe Bindl::Encrypt do
  include FakeFS::SpecHelpers
  before(:each) { @store = Bindl::Store.new('/test-store/').create! }

  # This is pretty much impossible to test without installing GPG keys
  # just for the test. That's a bit much.
  #
  # There are also impossibly many variations of having GPG installed.
  #
  # I'm sure there's some dependency injection and mocking way to do
  # this, but that's more code and logic than the module itself.
end
