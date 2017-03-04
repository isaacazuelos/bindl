require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Get < BaseCommand
      def description
        'Get a value out of an entry'
      end

      def parse(args)
        banners = [Parser.header(name, description),
                   Parser.usage(name, [:name, :keypath], {})]
        opts = Parser.options(args, banners, {})
        Parser.positional(args, [:name, :keypath], opts)
      end

      def run(opts)
        store = Bindl::Store.new
        entry = store[opts[:name]]
        raise "no file found for #{opts[:name]}" unless entry
        puts pretty entry.get opts[:keypath]
      end

      private

      def pretty(value)
        return value.to_yaml if [Hash, Array].include? value.class
        return value.to_s unless value.is_a? String
        value
      end
    end
  end
end
