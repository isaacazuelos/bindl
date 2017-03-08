require 'trollop'

require 'bindl/subcommand'

require 'bindl/subcommand/get'
require 'bindl/subcommand/path'
require 'bindl/subcommand/set'
require 'bindl/subcommand/show'

module Bindl
  # The `Bindl::App` module ties the appliation logic together.
  module App
    module_function

    def command_list
      return "no commands found\n" if Subcommand.commands.empty?
      Subcommand.commands.reduce('') do |a, c|
        a + '  ' + c.name.ljust(17) + c.description + "\n"
      end
    end

    def banner_text
      <<-BANNER
A place to keep your most valuable possessions.

Usage: bindl <command> [options]

Available commands:
#{command_list}
Available options:
BANNER
    end

    def parse_args(args)
      names = Subcommand.commands.map(&:name)
      Trollop.options(args) do
        version "bindl #{VERSION}"
        banner App.banner_text
        stop_on names
      end
    end

    # The entry point into our application. This is our `main`, as it were.
    def run(args)
      global_opts = parse_args(args)
      name = args.shift
      Trollop.educate if name.nil?
      command = Subcommand.commands.select { |cmd| cmd.name == name }.first
      # begin
      raise "unknown command '#{name}'" unless command
      command.run global_opts.merge command.parse args
      # rescue StandardError => e
      # puts "Error: #{e}."
      # end
    end
  end
end
