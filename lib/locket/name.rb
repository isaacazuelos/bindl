

module Locket
  # The `Locket::Name` module is a container for a few basic functions
  # used to work with names.
  #
  # Since data is kept in entires which are just files in the store,
  # we need the names to idenify the entires.
  #
  # We also don't want people to have to worry about the entire path,
  # since extensions should be invisible.
  module Name
    # raised for invalid names
    class InvalidNameError < RuntimeError
    end

    module_function

    # Extract the name that would be used to identify a file in a
    # store from that file's path.
    def from_path(_path, _root)
      nil
    end

    # Make sure that a name is valid.
    #
    # Returns the name if it's valid, raises otherwise.
    #
    # A name is valid if it would unambiguously specify a single file
    # in a store. Since we want to allow hidden files and relative
    # directories, we need to be careful about how these are parsed.
    def validate!(_name)
      nil
    end
  end
end
