require 'bindl/store'

module Bindl
  class Store
    # The meta entry used to store information about the store.
    def meta
      add(Bindl::META_NAME) unless include?(Bindl::META_NAME)
      self[Bindl::META_NAME]
    end
  end
end
