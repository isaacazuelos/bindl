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

    attr_reader :root

    def initialize(root = nil)
      @root = File.absolute_path(root || LOCKET_STORE_DIR)
    end

    def exist?
      File.directory? @root
    end

    def create!
      FileUtils.mkdir_p @root
      self
    end

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

    def include?(name)
      return nil unless exist?
      each.map { |path| Locket::Name.from_path path, @root }.include? name
    end

    def [](name)
      return nil unless exist?
      file = each.select do |path|
        Locket::Name.from_path(path, @root) == name
      end.first
      return nil unless file
      Locket::Entry.new(self, file)
    end

    def add(name)
      Entry.create! self, name
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
