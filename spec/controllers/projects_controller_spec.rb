# spec/controllers/projects_controller_spec.rb

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  # Include Devise test helpers
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:project) { create(:project, created_by: user.id) }

  before do
    # Use `sign_in` method from Devise test helpers
    sign_in user
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      it "updates the project" do
        new_name = "Updated Project Name"
        put :update, params: { id: project.id, project: { name: new_name } }
        project.reload
        expect(project.name).to eq(new_name)
      end
    end

    context "with invalid parameters" do
      it "does not update the project" do
        put :update, params: { id: project.id, project: { name: "" } }
        project.reload
        expect(project.name).not_to be_blank
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the project" do
      project_to_delete = create(:project, created_by: user.id)
      expect {
        delete :destroy, params: { id: project_to_delete.id }
      }.to change(Project, :count).by(-1)
    end
  end
end
