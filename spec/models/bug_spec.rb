# spec/models/bug_spec.rb

require 'rails_helper'

RSpec.describe Bug, type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      bug = Bug.new(description: 'Test description')
      expect(bug).not_to be_valid
      expect(bug.errors[:title]).to include("can't be blank")
    end
  end

end
