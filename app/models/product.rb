class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :purchases
end
