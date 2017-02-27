require 'bindl/version'
require 'bindl/app'
require 'bindl/store'
require 'bindl/entry'
require 'bindl/meta'

# The main namespace module for our library and application.
module Bindl
  # This is the default directory where data is kept.
  STORE_DIR = File.join(ENV['HOME'], '.bindl').freeze
  META_NAME = '.meta'.freeze
end
