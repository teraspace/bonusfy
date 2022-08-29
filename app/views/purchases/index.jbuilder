json.data @purchases do |purchase|
  json.merge! purchase.as_json
  json.category purchase.product.category
  json.product purchase.product
end

json.paginate do
  json.total_pages @purchases.total_pages
  json.per_page @purchases.per_page
  json.total_entries @purchases.total_entries
  json.current_page @purchases.current_page
end