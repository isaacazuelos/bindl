require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Init < BaseCommand
      def description
        'Create a store'
      end

      def parse(args)
        banners = [Parser.header(name, description),
                   Parser.usage(name)]
        opts = Parser.options(args, banners)
        Parser.positional(args, [], opts)
      end

      def run(_opts)
        store = Bindl::Store.new
        raise "store already exists at '#{store.root}'" if store.exist?
        store.create!
      end
    end
  end
end
