module SpreeProductFeed
  class FacebookCatalogFeedGenerateJob < ApplicationJob
    queue_as :default

    def perform()
      facebook_feed_path = Rails.root.join('public', 'facebook-catalog-feed.xml')
      store = ::Spree::Store.default
      File.open(facebook_feed_path, 'w+') do |fh|
        fh.write ::ApplicationController.new.render_to_string(
          :template => 'spree/facebook_feeds/index',
          :layout => false,
          :locals => { :@products => ::Spree::Product.feed_active, :current_store => store, :current_currency => store.default_currency }
        )
      end

      if File.exist?(facebook_feed_path)
        service = ActiveStorage::Blob.service
        file = File.open(facebook_feed_path)
        key = File.basename(facebook_feed_path)
        service.upload(key, file)
      end
    end

  end
end