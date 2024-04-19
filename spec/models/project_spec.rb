# spec/models/project_spec.rb

require 'rails_helper'

RSpec.describe Project, type: :model do
  it "is not valid without a name" do
    project = Project.new(description: "Example description", created_by: 1)
    expect(project).not_to be_valid
  end

  it "is not valid without a description" do
    project = Project.new(name: "Example Project", created_by: 1)
    expect(project).not_to be_valid
  end

  it "is not valid with a short description" do
    project = Project.new(name: "Example Project", description: "Short", created_by: 1)
    expect(project).not_to be_valid
  end

  it "is not valid without a creator" do
    project = Project.new(name: "Example Project", description: "Example description")
    expect(project).not_to be_valid
  end

  it "is valid with all required attributes" do
    project = Project.new(name: "Example Project", description: "Example description", created_by: 1)
    expect(project).to be_valid
  end
end
