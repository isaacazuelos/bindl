require 'bindl/subcommand'
require 'bindl/subcommand/parser'

require 'yaml'

module Bindl
  module Subcommand
    class Show < BaseCommand
      def description
        'Show an entry\'s contents'
      end

      def parse(args)
        banners = [Parser.header(name, description),
                   Parser.usage(name, [:name], {})]
        opts = Parser.options(args, banners, {})
        Parser.positional(args, [:name], opts)
      end

      def run(opts)
        store = Bindl::Store.new
        entry = store[opts[:name]]
        puts entry.data.to_yaml
      end
    end
  end
end
