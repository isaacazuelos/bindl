require 'bindl/keypath'

module Bindl
  # Set values deep within nested arrays and hashs.
  module Set
    class InsertError < RuntimeError; end

    module_function

    # Set `value` for `keypath` in a compound structure `data`.
    def set(data, keypath, value, preserve = false)
      set_keys(data, Bindl::Keypath.parse(keypath), value, preserve)
    end

    private_class_method

    def self.set_keys(data, keys, value, preserve)
      if keys.empty? || !collection?(data)
        raise(InsertError, 'cannot replace root') if preserve
        return nest(keys, val)
      end
      remainder, deepest = deepest(keys, data)
      key = remainder.shift
      remainder = [] if remainder.nil?
      insert(deepest, key, nest(remainder, value), preserve)
      data
    end

    # Find's the deepest existing collection along the path of the
    # keys.
    #
    # Assumes that `col` satisfies `collection?`.
    #
    # Returns the remaining keys and the deepest found collection.
    def self.deepest(keys, col)
      return [keys, col] if keys.count <= 1
      case col
      when Hash  then deepest_hash(keys, col)
      when Array then deepest_array(keys, col)
      end
    end

    # A helper for self.deepest, to break up the cases when the
    # collection is a `Hash`.
    #
    # Assumes col is a hash and keys is a non-empty array
    def self.deepest_hash(keys, col)
      return [keys, col] unless col.key?(keys.first)
      key = keys.shift
      return deepest(keys, col[key]) if collection?(col[key])
      [keys, col[key]]
    end

    # A helper for self.deepest, to break up the case when the
    # collecion is an `Array`. Only integer keys are allowed for
    # indexing arrays, and we can only continue deeper if they key a
    # valid index into the array.
    #
    # Assumes col is an array and keys is a non-empty array.
    def self.deepest_array(keys, col)
      key = keys.shift
      raise(InsertError, 'Non-integer key for array') unless key.is_a? Integer
      if key < col.count && key >= 0 && collection?(col)
        deepest(keys, col[key])
      else
        keys.unshift(key)
        [keys, col]
      end
    end

    # Is the value one of the supported collection types?
    def self.collection?(col)
      col.is_a?(Hash) || col.is_a?(Array)
    end

    # Insert the value `val` into the collection `col` at the given
    # `key`. Setting `preserve` will cause an `InvalidInsertion` to be
    # raised if a value it being overwritten. Returns the collection.
    def self.insert(col, key, val, preserve)
      unless insertable?(col, key, preserve)
        raise InsertError, "Cannot insert value at key #{key}"
      end
      col[key] = val
      col
    end

    # Can a value be inserted into the collection `col` at `key`?
    # We're saying it's valid to insert *just* past the end of an
    # array, pushing new elements.
    def self.insertable?(col, key, preserve)
      case col
      when Hash
        !(preserve && col.key?(key))
      when Array
        key.is_a?(Integer) && (preserve ? key == col.count : key <= col.count)
      else
        false
      end
    end

    def self.nest(keys, val)
      return val if keys.empty?
      key = keys.shift
      # nest inside arrays if key == 0
      return [nest(keys, val)] if key.is_a?(Integer) && key.zero?
      # nest in a hash if the key isn't an integer
      return { key => nest(keys, val) } unless key.is_a? Integer
      # non-zero integer keys are an error.
      raise(InsertError, "cannot create array with element at '#{key}'")
    end
  end
end

module Bindl
  # This is just a helper for adding #set directly on an entry.
  class Entry
    # set the value at `keypath` in the entry's data.
    def set(keypath, value, opts = { preserve: false })
      self.data = Set.set(data, keypath, value, opts[:preserve])
    end
  end
end
