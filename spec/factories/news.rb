FactoryBot.define do
  factory :news do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    source { Faker::Lorem.word }
    category { Category.order("RANDOM()").first || create(:category) }
    author { Faker::Name.name }
    published_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    provider_id { Faker::Number.number(digits: 10) }
  end
end
