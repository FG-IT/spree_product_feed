module SpreeProductFeed
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.scope :feed_active, -> { active.where(feed_active: true) }
        base.scope :feed_active_daily, -> { active.where(feed_active: true).where("spree_products.updated_at > ?", 30.hours.ago) }
        base.scope :feed_active_hourly, -> { active.where(feed_active: true).where("spree_products.updated_at > ?", 2.hours.ago) }
      end
    end
  end
end

::Spree::Product.prepend ::SpreeProductFeed::Spree::ProductDecorator unless ::Spree::Product.include?(::SpreeProductFeed::Spree::ProductDecorator)
