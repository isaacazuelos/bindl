$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# This is required, as per http://stackoverflow.com/questions/37280343/
# No idea why -- basically magic.
require 'pp'
require 'fakefs/spec_helpers'

require 'locket'
