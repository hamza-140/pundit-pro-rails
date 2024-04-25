# spec/models/project_spec.rb
require 'rails_helper'

RSpec.describe Project, type: :model do

  describe 'validations' do
    it 'validates presence of name' do
      project = Project.new(description: 'Test description')
      expect(project).not_to be_valid
      expect(project.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of description' do
      project = Project.new(name: 'Test Project')
      expect(project).not_to be_valid
      expect(project.errors[:description]).to include("can't be blank")
    end
  end

  describe 'custom methods' do
    it 'returns creator name' do
      creator = User.create(name: 'Creator User', email: 'creator@example.com', password: 'password')
      project = Project.create(name: 'Test Project', description: 'Test description', created_by: creator.id)
      expect(project.created_by).to eq(creator.id)
    end

  end
end
