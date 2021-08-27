FactoryBot.define do
  factory :user do
    password_digest { Faker::Lorem.characters(number:12) }
    email { Faker::Internet.email }
    name { Faker::Movies::HarryPotter.character }
    date_of_birth { Faker::Date.between(from: '1900-01-01', to: '2010-01-01') }
    profile_picture { Faker::Avatar.image }
    obituary { Faker::Quote.famous_last_words }
  end
end