xml.tag!("g:id", variant.feed_id)

unless product.property("g:title").present?
  xml.tag!("g:title", product.name.truncate(150, separator: /\s/, omission: ''))
end

unless product.property("g:description").present?
  if product.description.present?
    xml.tag!("g:description", product.description.truncate(9999, separator: /\s/, omission: ''))
  else
    xml.tag!("g:description", product.title)
  end
end

xml.tag!("g:link", "#{current_store.formatted_url}/products/#{product.slug}?variant=#{variant.id}")
xml.tag!("g:image_link", variant.feed_image_link)
xml.tag!("g:availability", variant.in_stock? ? "in stock" : "out of stock")
xml.tag!("g:brand", product&.main_brand.present? ? product.main_brand : "Everymarket")
xml.tag!("g:condition", "new")

if defined?(variant.compare_at_price) && !variant.compare_at_price.nil?
  if variant.compare_at_price > product.price
    xml.tag!("g:price", variant.compare_at_price.to_s + " " + current_currency)
    xml.tag!("g:sale_price", variant.price_in(current_currency).amount.to_s + " " + current_currency)
  else
    xml.tag!("g:price", variant.price_in(current_currency).amount.to_s + " " + current_currency)
  end
else
  xml.tag!("g:price", variant.price_in(current_currency).amount.to_s + " " + current_currency)
end

if variant.unique_identifier.present?
  xml.tag!("g:" + variant.unique_identifier_type, variant.unique_identifier)
else
  if variant.has_attribute?(:barcode) && variant.barcode.present?
    xml.tag!("g:gtin", variant.barcode)
  else
    xml.tag!("g:mpn", (product&.main_brand&.gsub(/\W/, '').try(:[], 0, 2).try(:upcase) || '') + variant.id.to_s)
  end
end
xml.tag!("g:sku", variant.sku)
xml.tag!("g:item_group_id", variant.feed_item_group_id)

options_xml_hash = Spree::Variants::XmlFeedOptionsPresenter.new(variant).xml_options
options_xml_hash.each do |ops|
  if ops.option_type[:name] == "color"
    xml.tag!("g:" + ops.option_type.presentation.downcase, ops.name)
  else
    xml.tag!("g:" + ops.option_type.presentation.gsub(/[^a-z0-9_]+/i, '_').downcase, ops.presentation)
  end
end

unless product.product_properties.blank?
  xml << render(partial: "spree/facebook_feeds/props", locals: {product: product})
end
