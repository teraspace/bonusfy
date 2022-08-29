FactoryBot.define do
  factory :category do |f|
    f.name { Faker::Commerce.department }


    after :create do |category|
      create_list :product, 200, category: category, user: User.last
    end
  end
end
