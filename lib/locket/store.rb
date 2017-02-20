# This file is responsible for working with the store that is the root
# of our locket directory.

require 'fileutils'
require 'find'

require 'locket/name'

module Locket
  # The `Locket::Store` class models the directory and operations that
  # are valid forour locket.
  #
  # We also don't want people to have to worry about the entire path,
  # since extensions should be invisible.
  class Store
    # raised when the store needs to exist
    class StoreDoesNotExistError < RuntimeError; end

    # The path to the root of the locket directory where the files are kept.
    attr_reader :root

    # Create a new store, setting it's `root`.
    # Default `root` is `LOCKET_STORE_DIR`
    def initialize(root = nil)
      @root = File.absolute_path(root || LOCKET_STORE_DIR)
    end

    # Does the directory for this store exist on the filesystem?
    def exist?
      File.directory? @root
    end

    # Create the root directory for this store. This will create intermediate
    # directories if requried. Returns `self`.
    def create!
      FileUtils.mkdir_p @root
      self
    end

    # Return an array of the full path to each file that looks like a valid
    # entry in the `Store`'s directory. By default this ignores hidden files,
    # but you can include them by setting `hidden: true`.
    def each(opts = { hidden: false })
      res = []
      return res unless exist?
      Find.find(@root) do |child|
        path = File.absolute_path(child)
        next unless valid_name?(path) && File.file?(path)
        next if hidden?(path) && !opts[:hidden]
        res << path
      end
      res
    end

    # Is there an entry for the given `name` in this store?
    def include?(name)
      return nil unless exist?
      each.map { |path| Locket::Name.from_path path, @root }.include? name
    end

    # Retrive an entry from the store by it's name.
    #
    # Raises:
    #   - if the store doesn't exist
    #   - if the name is invalid
    #   - if the entry doesn't exist
    def [](name)
      return nil unless exist?
      file = each.select do |path|
        Locket::Name.from_path(path, @root) == name
      end.first
      return nil unless file
      Locket::Entry.new(self, file)
    end

    # Add an entry to the store, create the file as needed.
    # Returns the entry.
    def add(name)
      Entry.create! self, name
      self[name]
    end

    ### private instance methods

    # Does a path contain a hidden component?
    private def hidden?(path)
      name = Locket::Name.from_path path, @root
      name.split('/').any? { |comp| comp.start_with? '.' }
    end

    # Does a path map to a valid name?
    private def valid_name?(path)
      return false if path == @root
      begin
        Locket::Name.from_path path, @root
      rescue Locket::Name::InvalidNameError
        return false
      end
      true
    end
  end
end
