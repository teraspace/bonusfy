class Product < ApplicationRecord
  belongs_to :user
  # Review: Los productos debían estar asociados a una o más categorías.
  belongs_to :category
  has_many :purchases
end
