require 'yaml'

module Bindl
  # A keypath is a string which represents a series of keys that you
  # can use to index a deeply-nested value in data.
  module Keypath
    # An error raised by attempts to parse invalid keypaths
    class KeypathError < RuntimeError; end

    module_function

    # Parse a keypath string and return an array of the actual keys.
    def parse(keypath)
      raise(KeypathError, 'keypath contains whitespace') if keypath[/\s/]
      keypath.split('.').map do |segment|
        segment = YAML.load(segment)
        raise KeypathError, '' if [Hash, Array, Set].include?(segment.class)
        segment
      end
    end
  end
end
