FactoryBot.define do
  factory :page do
    url { Faker::Internet.url }
    title { Faker::Lorem.sentence }
    status { [200, 301, 500].sample }

    initialize_with { new(attributes) }
  end
end
