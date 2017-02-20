require 'locket/version'
require 'locket/app'
require 'locket/store'
require 'locket/entry'

# The main namespace module for our library and application.
module Locket
  # This is the default directory where data is kept.
  LOCKET_STORE_DIR = File.join(ENV["HOME"], ".locket").freeze
end
