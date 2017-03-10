require 'bindl/subcommand'
require 'bindl/subcommand/parser'

module Bindl
  module Subcommand
    class Edit < BaseCommand
      def description
        'Edit an entry'
      end

      def parse(args)
        pos = [:name]
        banners = [Parser.header(name, description),
                   Parser.usage(name, pos)]
        opts = Parser.options(args, banners)
        Parser.positional(args, pos, opts)
      end

      def run(opts)
        store = Bindl::Store.new
        entry = store[opts[:name]]
        raise "no file found for #{opts[:name]}" unless entry
        raise 'will not edit encrypted entries' if entry.encrypt?
        open_in_editor entry.path
      end

      def open_in_editor(path)
        # What's the environment's VISUAL or EDITOR variable. This
        # prefers VISUAL, since that seems to be the way to go.
        # http://unix.stackexchange.com/questions/4859/
        editor = ENV['VISUAL'] || ENV['EDITOR'] || raise('no editor is set')
        system(editor, Shellwords.escape(path))
      end
    end
  end
end
