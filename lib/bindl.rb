require 'bindl/version'
require 'bindl/app'
require 'bindl/store'

require 'bindl/entry'
require 'bindl/get'
require 'bindl/set'

require 'bindl/meta'

# The main namespace module for our library and application.
module Bindl
  # This is the default directory where data is kept.
  STORE_DIR = File.join(ENV['HOME'], '.bindl').freeze
  # The name of the meta entry used for store metadata.
  META_NAME = '.meta'.freeze
  # The keypath for the recipent in the meta entry.
  ID_KEYPATH = 'encryption.gpg-id'.freeze
end
