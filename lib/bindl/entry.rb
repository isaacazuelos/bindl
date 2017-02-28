# This file is responsible for wrapping the sorts of operations we'd want to
# do to files in a store.

require 'yaml'
require 'fileutils'

require 'bindl/name'
require 'bindl/encrypt'

module Bindl
  # An Entry is a wrapper around a file in the store.
  class Entry
    # The entry exists, but shouldn't
    class EntryExistsError < RuntimeError; end

    # The entry doesn't exist
    class EntryDoesNotExistError < RuntimeError; end

    # The file cannot be parsed
    class EntrySyntaxError < RuntimeError; end

    # The absolute path of the file that an entry wraps.
    attr_reader :path

    # Create a new entry in a store, given the full path.
    # You typically wouldn't call this yourself, but work with `Store#[]`.
    def initialize(store, path)
      @path = path
      @store = store
      Name.valid! Name.from_path(path, '/')
      exist!
    end

    # Is the entry encrypted?
    def encrypt?
      @encrypter = Bindl::Encrypt.new @store if @path.end_with? '.gpg'
    end

    # Create the file for an entry, returning an entry to wrap it.
    def self.create!(store, name, opts = { encrypt: false })
      raise Bindl::Store::StoreDoesNotExistError unless store.exist?
      Name.valid! name
      suffix = '.yml' + (opts[:encrypt] ? '.gpg' : '')
      path = File.join(store.root, name + suffix)
      raise EntryExistsError if File.file? path
      FileUtils.touch path
      Entry.new(store, path)
    end

    # Delete the file for the entry. After this is called the object remains,
    # but it's is useless. Don't use it, or nonsense happens.
    def delete!
      exist!
      File.unlink @path
      @path = nil
    end

    # Get the data encoded in the file.
    def data
      exist!
      begin
        data = File.read @path
        data = @encrypter.decrypt(data) if encrypt?
        YAML.load data
      rescue Psych::SyntaxError
        raise EntrySyntaxError
      end
    end

    # Write new data to the file.
    def data=(new_data)
      new_data = new_data.to_yaml
      new_data = @encrypter.encrypt(new_data) if encrypt?
      File.write(@path, new_data)
    end

    # Ensure that both the store and file for this entry exist, raise
    # appropriately otherwise.
    private def exist!
      unless File.directory? @store.root
        raise Bindl::Store::StoreDoesNotExistError
      end
      raise EntryDoesNotExistError unless File.file? @path
    end
  end
end
