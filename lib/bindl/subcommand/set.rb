require 'bindl/subcommand'
require 'bindl/subcommand/parser'

require 'yaml'

module Bindl
  module Subcommand
    class Set < BaseCommand
      def description
        'Set a value inside an entry'
      end

      def preserve_flag
        {
          long: :preserve,
          short: 'p',
          description: 'Preserve existing values',
          default: false
        }
      end

      def parse(args)
        pos = [:name, :keypath, :value]
        banners = [Parser.header(name, description), Parser.usage(name, pos)]
        opts = Parser.options(args, banners, [preserve_flag])
        Parser.positional(args, pos, opts)
      end

      def run(opts)
        store = Bindl::Store.new
        entry = store[opts[:name]]
        raise "No entry found for '#{opts[:name]}'" unless entry
        value = YAML.load(opts[:value])
        entry.set(opts[:keypath], value, preserve: opts[:preserve])
      end
    end
  end
end
