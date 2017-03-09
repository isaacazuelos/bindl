require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class List < BaseCommand
      def description
        'List your bindl\'s contents'
      end

      def simple_flag
        {
          long: :simple,
          short: 's',
          description: 'Show a flat listing',
          default: false
        }
      end

      def hidden_flag
        {
          long: :hidden,
          short: 'h',
          description: 'Show hidden entries',
          default: false
        }
      end

      def parse(args)
        flags = [simple_flag, hidden_flag]
        banners = [Parser.header(name, description),
                   Parser.usage(name, [], flags)]
        opts = Parser.options(args, banners, flags)
        Parser.positional(args, [], opts)
      end

      def run(opts)
        store = Bindl::Store.new
        return puts store.each(hidden: opts[:hidden]) if opts[:simple]
        system 'tree ' + (opts[:hidden] ? ' -a ' : '') + " #{store.root} "
      end
    end
  end
end
