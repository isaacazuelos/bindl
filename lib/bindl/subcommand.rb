module Bindl
  module Subcommand
    class << self
      attr_accessor :commands
    end
    self.commands = []

    # This is a base class to use for writing subcommands.
    class BaseCommand
      # We create an instance and store it in `Command.commands`
      # whenever a subclass is defined. This is kind of a silly way to
      # avoid registering the classes during definition.
      def self.inherited(subclass)
        Bindl::Subcommand.commands << subclass.new
      end

      # Compute the name to use for the command based on the sublcass
      # name.
      def name
        prefix_length = 19 # 'bindl::subcommand::'.length
        self.class.name.downcase[prefix_length..-1]
      end

      ### Override these methods for your subclasses

      # A very short description of what the command does. It should
      # start with an uppercase letter, but not be a sentence. e.g.
      # "Prints an entry".
      def description
        raise "description not provided for command #{name}"
      end

      # This method takes a list of arguments, like ARGV, and parses
      # them into a format that `#run` can use.
      def parse(args)
        { unused: args }
      end

      # Run the actual command to do things.
      def run(_options)
        raise "command '#{name}' is not implemented"
      end
    end
  end
end
