require 'faker'

FactoryBot.define do
  factory :product do |f|
    association :user
    association :category
    f.name { Faker::Commerce.product_name }
    f.brand { Faker::Appliance.brand  }
    f.units { Faker::Number.between(from: 10, to: 100) }
    f.vendor { Faker::App.name }
    f.price { Faker::Commerce.price }

    f.extra { 
      {
        "color": Faker::Commerce.color,
        "material":  Faker::Commerce.material,
        "width":  Faker::Number.between(from: 1, to: 10),
        "length":  Faker::Number.between(from: 1, to: 10),
        "heigth":  Faker::Number.between(from: 1, to: 10),
        "weigth":  Faker::Number.between(from: 1, to: 10),
        "description": Faker::Lorem.paragraph
      } 
    }
    after :create do |product|
      units = Faker::Number.between(from: 1, to: 10)
      purchase_count = Faker::Number.between(from: 5, to: 50)
      create_list :purchase,
      purchase_count,
      product_id: product.id,
      buyer_name: Faker::Name.name_with_middle,
      amount: product.price * units
    end
  end
end
