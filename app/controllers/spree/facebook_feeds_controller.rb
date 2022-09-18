module Spree
  class FacebookFeedsController < ::Spree::FeedsController
    def hourly
      @products = ::Spree::Product.feed_active_hourly

      render 'index'
    end

    def daily
      @products = ::Spree::Product.feed_active_daily

      render 'index'
    end

    def full
      filename = 'facebook-catalog-feed.xml'
      if ActiveStorage::Blob.service.exist?(filename)
        if ::SpreeProductFeed.serve_directly
          respond_to do |format|
            format.xml { render body: ActiveStorage::Blob.service.download(filename) }
          end
        else
          return redirect_to ActiveStorage::Blob.service.url(filename)
        end
      else
        render plain: '404 Not Found', status: 404
      end
    end
  end
end