require 'rails_helper'

RSpec.describe User, type: :model do
  it "is not valid without an email" do
    user = User.new(password: "password", name: "example_user",role:"manager")
    expect(user).not_to be_valid
  end

  it "is not valid without a password" do
    user = User.new(email: "user@example.com", name: "example_user",role:"manager")
    expect(user).not_to be_valid
  end

  it "is not valid without a name" do
    user = User.new(email: "user@example.com", password: "password",role:"manager")
    expect(user).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    existing_user = User.create(email: "existing@example.com",name:"existing_user", password: "password",role:"manager")
    user = User.new(email: "existing@example.com", password: "password", name: "existing_user",role:"manager")
    expect(user).not_to be_valid
  end
  it "is not valid without role" do
    user = User.new(email: "user@example.com", password: "password", name: "existing_user")
    expect(user).not_to be_valid
  end

  it "is valid with all required attributes" do
    user = User.new(email: "user@example.com", password: "password", name: "example_user",role:"manager")
    expect(user).to be_valid
  end
end
