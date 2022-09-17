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
      page = params[:page].present? ? params[:page] : 1
      page_size = params[:page_size].present? ? params[:page_size] : 5000
      @products = ::Spree::Product.feed_active.limit(page_size).offset((page - 1) * page_size)

      render 'index'
    end
  end
end