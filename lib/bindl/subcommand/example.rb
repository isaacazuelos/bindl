module Bindl
  module Subcommand
    class Example < BaseCommand
      def description
        'An example command that does nothing'
      end

      def run(options)
        puts "#{name} called with: #{options}"
      end
    end
  end
end
