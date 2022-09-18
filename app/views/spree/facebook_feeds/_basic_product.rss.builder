xml.tag!("g:id", "#{product.master.feed_id}")

unless product.property("g:title").present?
  xml.tag!("g:title", product.name.truncate(150, separator: /\s/, omission: ''))
end
unless product.property("g:description").present?
  xml.tag!("g:description", product.description.truncate(9999, separator: /\s/, omission: ''))
end

xml.tag!("g:link", "#{current_store.formatted_url}/#{product.slug}")
xml.tag!("g:image_link", product.master.feed_image_link)
xml.tag!("g:availability", product.in_stock? ? "in stock" : "out of stock")
if defined?(product.compare_at_price) && !product.compare_at_price.nil?
  if product.compare_at_price > product.price
    xml.tag!("g:price", product.compare_at_price.to_s + " " + current_currency)
    xml.tag!("g:sale_price", product.price_in(current_currency).amount.to_s + " " + current_currency)
  else
    xml.tag!("g:price", product.price_in(current_currency).amount.to_s + " " + current_currency)
  end
else
  xml.tag!("g:price", product.price_in(current_currency).amount.to_s + " " + current_currency)
end
if product.unique_identifier.present?
  xml.tag!("g:" + product.unique_identifier_type, product.unique_identifier)
else
  if product.master.has_attribute?(:barcode)
    xml.tag!("g:gtin", product.master.barcode)
  else
    xml.tag!("g:mpn", (product&.main_brand&.gsub(/\W/, '').try(:[], 0, 2).try(:upcase) || '') + product.master.id.to_s)
  end
end
xml.tag!("g:sku", product.sku)

unless product.product_properties.blank?
  xml << render(partial: "spree/facebook_feeds/props", locals: {product: product})
end
