module SpreeProductFeed
  module Spree
    module VariantDecorator
      def feed_id
        "#{feed_prefix}_#{self.product_id}_#{self.id}"
      end unless method_defined?(:feed_id)

      def feed_image_link
        image = self.images&.first || self.product.master.images&.first
        if image&.attached_file.present?
          image.large_image_url
        end
      end unless method_defined?(:feed_image_link)

      def feed_item_group_id
        "#{feed_prefix.upcase}#{self.product_id}"
      end unless method_defined?(:feed_item_group_id)

      def feed_prefix
        defined?(current_store) ? current_store.code : ::Spree::Store.default.code
      end unless method_defined?(:feed_prefix)
    end
  end
end

::Spree::Variant.prepend ::SpreeProductFeed::Spree::VariantDecorator unless ::Spree::Variant.include?(::SpreeProductFeed::Spree::VariantDecorator)
