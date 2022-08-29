class Purchase < ApplicationRecord
  belongs_to :product

  scope :created_start, lambda {|start_date| where("created_at >= ?", start_date )}
  scope :created_end, lambda {|end_date| where("created_at <= ?", end_date )}
  scope :by_units, lambda {|units| where("units >= ?", units)}
  scope :by_amount, lambda {|amount| where("amount >= ?", amount)}
  scope :by_buyer, lambda {|buyer| where("buyer_name ilike '%#{buyer}%'")}
  scope :by_product, lambda {|product| where("products.name ilike '%?%'", product)}
  scope :by_product_color, lambda {|color| joins(product: :category).where("products.extra->>'color' = ?", color)}
  scope :by_product_material, lambda {|material| joins(product: :category).where("products.extra->>'material' ilike '%#{material}%'")}
  scope :by_product_weigth, lambda {|weigth| joins(product: :category).where("products.extra->>'weigth' > ?", weigth)}
end
