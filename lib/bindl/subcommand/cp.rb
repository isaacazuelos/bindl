require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Cp < BaseCommand
      def description
        'Copy an entry'
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
        pos = [:old, :new]
        flags = [encrypt_flag]
        banners = [Parser.header(name, description),
                   Parser.usage(name, pos, flags)]
        opts = Parser.options(args, banners, flags)
        Parser.positional(args, pos, opts)
      end

      def run(opts)
        store = Bindl::Store.new
        old = store[opts[:old]]
        raise "no file found for #{opts[:name]}" unless old
        new = store.add(opts[:new], encrypt: opts[:encrypt])
        new.data = old.data
      end
    end
  end
end
