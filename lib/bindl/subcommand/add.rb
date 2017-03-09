require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Add < BaseCommand
      def description
        'Make a new entry'
      end

      def encrypt_flag
        {
          long: :encrypt,
          short: 'e',
          description: 'Encrypt the entry',
          default: false
        }
      end

      def parse(args)
        pos = [:name]
        banners = [Parser.header(name, description),
                   Parser.usage(name, pos)]
        opts = Parser.options(args, banners, [encrypt_flag])
        Parser.positional(args, pos, opts)
      end

      def run(opts)
        store = Bindl::Store.new
        store.add(opts[:name], encrypt: opts[:encrypt])
      end
    end
  end
end
