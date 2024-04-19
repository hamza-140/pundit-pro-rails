# spec/factories/projects.rb

FactoryBot.define do
  factory :project do
    name { "Sample Project" }
    description { "Sample project description" }
    created_by { association(:user) }
  end
end
