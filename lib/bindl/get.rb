require 'bindl/keypath'

module Bindl
  # Get values out of nested data structures.
  module Get
    module_function

    # Fetch a value out of the compound data structure `data`, like
    # `Hash#dig` but raising on missing values. The `keypath` is
    # expected to be a string as described in `Bindl::Keypath.parse`.
    def get(data, keypath)
      get_keys(data, Bindl::Keypath.parse(keypath))
    end

    private_class_method

    # Like `get`, but using parsed keys.
    # This is the function that we recursively call as we dig.
    def get_keys(data, keys)
      return data if keys.empty?
      case data
      when Hash  then get_from_hash(data, keys)
      when Array then get_from_array(data, keys)
      else raise KeyError, "no value found for keys: #{keys}"
      end
    end

    # Get a value out of a hash.
    # Assumes data is a hash, keys is non-empty.
    def self.get_from_hash(data, keys)
      key = keys.shift
      raise KeyError, "no value found for key: #{key}" unless data.key? key
      get_keys(data[key], keys)
    end

    # Get a value out of an array.
    # Assumes data is an array, keys is non-empty.
    def self.get_from_array(data, keys)
      key = keys.shift
      unless key.is_a?(Integer) && (key >= 0) && (key < data.count)
        raise KeyError, "no value found for key: #{key}"
      end
      get_keys(data[key], keys)
    end
  end
end
