require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Path < BaseCommand
      def description
        'Print your store\'s path'
      end

      def parse(args)
        banners = [Parser.header(name, description),
                   Parser.usage(name)]
        opts = Parser.options(args, banners)
        Parser.positional(args, [], opts)
      end

      def run(_opts)
        store = Bindl::Store.new
        puts store.root
      end
    end
  end
end
