FactoryBot.define do
  factory :purchase do |f|
    f.units { Faker::Number.between(from: 1, to: 10) }
  end
end
