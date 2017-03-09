require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Rm < BaseCommand
      def description
        'Delete an entry'
      end

      def parse(args)
        pos = [:name]
        banners = [Parser.header(name, description),
                   Parser.usage(name, pos, {})]
        opts = Parser.options(args, banners, [])
        Parser.positional(args, pos, opts)
      end

      def run(opts)
        store = Bindl::Store.new
        entry = store[opts[:name]]
        entry.delete!
      end
    end
  end
end
