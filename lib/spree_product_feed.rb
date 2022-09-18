require "spree_core"
require "spree_extension"
require "spree_product_feed/engine"
require "spree_product_feed/version"
require "deface"

module SpreeProductFeed
  @serve_directly = true

  class << self
    attr_accessor :serve_directly
  end
end
