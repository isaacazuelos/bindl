require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Mv < BaseCommand
      def description
        'Move an entry, preserving encryption'
      end

      def parse(args)
        pos = [:old, :new]
        banners = [Parser.header(name, description),
                   Parser.usage(name, pos)]
        opts = Parser.options(args, banners)
        Parser.positional(args, pos, opts)
      end

      def run(opts)
        store = Bindl::Store.new
        old = store[opts[:old]]
        raise "no file found for #{opts[:name]}" unless old
        new = store.add(opts[:new], encrypt: old.encrypt?)
        new.data = old.data
        old.delete!
      end
    end
  end
end
