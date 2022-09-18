# frozen_string_literal: true

xml = Builder::XmlMarkup.new
xml.instruct! :xml, version: "1.0"
xml.rss("xmlns:g" => "http://base.google.com/ns/1.0", :version => "2.0") {
  xml.channel {
    xml.title(current_store.name)
    xml.link(current_store.url)
    xml.description("Find out about new products first! Always be in the know when new products become available")

    if defined?(current_store.default_locale) && !current_store.default_locale.nil?
      xml.language(current_store.default_locale.downcase)
    else
      xml.language("en-us")
    end

    @products.each do |product|
      unless product.feed_active?
        next
      end

      if product.variants_and_option_values(current_currency).any?
        product.variants.each do |variant|
          if variant.show_in_product_feed?
            xml.item do
              xml << render(partial: "spree/facebook_feeds/complex_product", locals: {current_store: current_store, current_currency: current_currency, product: product, variant: variant}).gsub(/^/, "      ")
            end
          end
        end
      else
        xml.item do
          xml << render(partial: "spree/facebook_feeds/basic_product", locals: {current_store: current_store, current_currency: current_currency, product: product}).gsub(/^/, "      ")
        end
      end
    end
  }
}
