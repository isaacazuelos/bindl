module Bindl
  module Subcommand
    # This module is wrapper around Trollop to ensure consistency and
    # avoid duplication.
    module Parser
      class ParserError < RuntimeError; end

      module_function

      def options(args, banners, opts = [])
        Trollop.options(args) do
          banners.each { |line| banner line }
          opts.each do |o|
            opt(o[:long], o[:description],
                short:   o[:short],
                default: o[:default])
          end
        end
      end

      def positional(args, symbols, opts = {})
        symbols.each do |symbol|
          raise(ParserError, "required <#{symbol}> not found") if args.empty?
          opts[symbol] = args.shift
        end
        unless args.empty?
          raise(ParserError, "unknown argument '#{args.shift}'")
        end
        opts
      end

      # Build a standardized header out of the command name and
      def header(name, desc)
        "bindl #{name} - #{desc}"
      end

      # Build a usage string from the symbols used for positional
      # arugments, and the options.
      def usage(name, symbols = [], opts = [])
        add_options(add_positional("Usage: bindl #{name}", symbols), opts)
      end

      private_class_method

      def add_positional(line, symbols)
        symbols.each do |symbol|
          line += " <#{symbol}>"
        end
        line
      end

      def add_options(line, opts)
        opts.each do |opt|
          line += " [-#{opt[:short]}|--#{opt[:long]}]"
        end
        line
      end
    end
  end
end
