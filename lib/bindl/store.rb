# This file is responsible for working with the store that is the root
# of our directory.

require 'fileutils'
require 'find'

require 'bindl/name'

module Bindl
  # The `Bindl::Store` class models the directory and operations that
  # are valid for our storage directory.
  #
  # We also don't want people to have to worry about the entire path,
  # since extensions should be invisible.
  class Store
    # Raised when the store needs to exist
    class StoreDoesNotExistError < RuntimeError; end

    # The path to the root of the directory where the files are kept.
    attr_reader :root

    # Create a new store, setting it's `root`. Default `root` is
    # `STORE_DIR`
    def initialize(root = nil)
      @root = File.absolute_path(root || STORE_DIR)
    end

    # Does the directory for this store exist on the filesystem?
    def exist?
      File.directory? @root
    end

    # Create the root directory for this store. This will create
    # intermediate directories if requried. Returns `self`.
    def create!
      FileUtils.mkdir_p @root
      self
    end

    # Return an array of the full path to each file that looks like a
    # valid entry in the `Store`'s directory. By default this ignores
    # hidden files, but you can include them by setting `hidden:
    # true`.
    def each(hidden: false)
      res = []
      return res unless exist?
      Find.find(@root) do |child|
        path = File.absolute_path child, @root
        name = as_name? path
        next unless name
        next if Name.hidden?(name) && !hidden
        res << path
      end
      res
    end

    # Is there an entry for the given `name` in this store?
    def include?(name)
      return nil unless exist?
      each(hidden: true).map do |path|
        Bindl::Name.from_path path, @root
      end.include? name
    end

    # Retrive an entry from the store by it's name.
    #
    # Raises:
    #   - if the store doesn't exist
    #   - if the name is invalid
    #   - if the entry doesn't exist
    def [](name)
      return nil unless exist?
      file = each(hidden: true).select do |path|
        Bindl::Name.from_path(path, @root) == name
      end.first
      return nil unless file
      Bindl::Entry.new self, file
    end

    # Add an entry to the store, create the file as needed. Returns
    # the entry.
    def add(name, opts = { encrypt: false })
      Entry.create! self, name, encrypt: opts[:encrypt]
      self[name]
    end

    private
    
    # Is `path` a name?
    # To be an entry, it needs to be a valid name and exist.
    def as_name?(path)
      return nil unless File.file? path
      begin
        Name.from_path path, @root
      rescue Name::NameError
        nil
      end
    end
  end
end
