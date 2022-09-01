class Purchase < ApplicationRecord
  belongs_to :product

  # Review: Considerando performance,
  # filtrar compras una base con altas cantidades de registros requiere las siguientes consideraciones:
  # - Índices:
  #   - El único índice que existe en la tabla de compras servirá para filtrar por algún producto.
  #   - Me faltó indices respecto a los otros atributos y/o compuestos.
  # - Las compras deben registrar info transaccional por lo que registrar además del product_id
  #   registrar además el product_name es algo loco así filtrar por product name no requiere joins.
  
  # Review: Acá me faltó registrar en qué categoría se hicieron la compras. Lo puedes obtener a través de producto
  #         pero si a futuro cambias la categoría de los productos, no hay certeza de a través de qué categoría
  #         se hizo la compra. No es algo grave.
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
