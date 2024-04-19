# spec/factories/bugs.rb

FactoryBot.define do
  factory :bug do
    title { "Example Bug" }
    description { "Example description for the bug." }
    association :project
    association :user
    created_by { user.id }
  end
end
