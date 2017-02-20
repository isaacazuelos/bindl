require 'yaml'
require 'fileutils'

require 'locket/name'

module Locket
  class Entry
    class EntryExistsError < RuntimeError; end
    class EntryDoesNotExistError < RuntimeError; end
    class EntrySyntaxError < RuntimeError; end

    attr_accessor :path

    def initialize(store, path)
      @path = path
      @store = store
      Name.validate!(Name.from_path(path, '/'))
      exist!
    end

    def self.create!(store, name)
      raise Store::StoreDoesNotExistError unless store.exist?
      Name.validate!(name)
      path = File.join(store.root, name + '.yml')
      raise EntryExistsError if File.file? path
      FileUtils.touch path
    end

    def delete!
      exist!
      File.unlink @path
      @path = nil
    end

    def data
      exist!
      begin
        res = YAML.load File.read @path
      rescue Psych::SyntaxError
        raise EntrySyntaxError
      end
      res
    end

    def data=(new_data)
      File.write(@path, new_data.to_yaml)
    end

    private def exist!
      raise Store::StoreDoesNotExistError unless File.directory? @store.root
      raise EntryDoesNotExistError unless File.file? @path
    end
  end
end
