# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    name { Faker::Name.name }
    role { "manager" }
  end
end
