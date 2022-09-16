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
      @products = ::Spree::Product.feed_active

      render 'index'
    end
  end
end