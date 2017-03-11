# This file is responsible for extracting names from paths, and name
# validation.

module Bindl
  # The `Bindl::Name` module is a container for a few basic functions
  # used to work with names.
  #
  # Since data is kept in entires which are just files in the store,
  # we need the names to idenify the entires.
  #
  # We also don't want people to have to worry about the entire path,
  # since extensions should be invisible.
  module Name
    # raised for invalid names
    class NameError < RuntimeError; end

    module_function

    # Extract the name that would be used to identify a file in a
    # store from that file's path.
    #
    # Paths must be absolute or relative to the working directory.
    def from_path(path, root)
      path, root = from_path_sanity_check(path, root)
      dir = File.dirname(path)[root.length..-1]
      file = File.basename path
      file = File.basename(file, '.*') while File.extname(file) != ''
      file = File.join(dir, file)[1..-1] # +1 for the leading '/'
      valid! file
    end

    # Make sure that a name is valid.
    #
    # Returns the name if it's valid, raises otherwise.
    #
    # A name is valid if it would unambiguously specify a single file
    # in a store. Since we want to allow hidden files and relative
    # directories, we need to be careful about how these are parsed.
    def valid!(name)
      raise NameError, 'names cannot end in "/"' if name.end_with? '/'
      raise NameError, 'names cannot end in "."' if name.end_with? '.'
      unless File.extname(name) == ''
        raise NameError, 'names cannot have file extensions'
      end
      name
    end

    # Does a name represent a hidden file, i.e. a file starting with `.`.
    def hidden?(name)
      name.split('/').any? { |comp| comp.start_with? '.' }
    end

    private_class_method

    # Some sanity checks for the inputs to `Bindl::Name.from_path`,
    # to make sure that the `path` is a _file_ in `root`.
    def from_path_sanity_check(path, root)
      raise NameError, 'path cannot be a directory' if path.end_with? '/'
      root = File.absolute_path root
      path = File.absolute_path(path, root)
      raise 'path must be in root' unless path.start_with? root
      [path, root]
    end
  end
end
