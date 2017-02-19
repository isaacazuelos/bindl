# This file is responsible for working with the store that is the root
# of our locket directory.

module Locket
  # The `Locket::Store` class models the directory and operations that
  # are valid forour locket.
  #
  # We also don't want people to have to worry about the entire path,
  # since extensions should be invisible.
  class Store
    # raised when the store needs to exist
    class StoreDoesNotExistError < RuntimeError; end

    attr_reader :root

    def initialize(root = nil) end

    def exist?; end

    def create; end

    def [](name) end

    def each; end

    def include?(name); end
  end
end
