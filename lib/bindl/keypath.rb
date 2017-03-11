require 'yaml'

module Bindl
  # A keypath is a string which represents a series of keys that you
  # can use to index a deeply-nested value in data.
  module Keypath
    module_function

    # Parse a keypath string and return an array of the actual keys.
    def parse(keypath)
      if /\s/ =~ keypath
        raise(KeyError, "keypath '#{keypath}' contains whitespace")
      end
      keypath.split('.').map { |segment| parse_segment segment }
    end

    private_class_method

    def parse_segment(segment)
      segment = YAML.load(segment)
      if [Hash, Array, Set].include?(segment.class)
        raise(KeyError, 'keys must be scalar')
      end
      segment
    end
  end
end
