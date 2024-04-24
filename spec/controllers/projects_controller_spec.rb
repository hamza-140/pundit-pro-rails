require "rails_helper"

RSpec.describe ProjectsController, type: :controller do
  # Include Devise test helpers
  include Devise::Test::ControllerHelpers

  let(:manager) { create(:user, role: "manager") }
  let(:developer) { create(:user, role: "developer") }
  let(:qa) { create(:user, role: "quality_assurance") }
  let(:project) { create(:project, created_by: manager.id) }

  # before do
  #   # Use `sign_in` method from Devise test helpers
  #   sign_in manager
  # end

  describe "GET #show" do
  sign_in user
  let(:project) { create(:project, created_by: user.id) }

  it "returns a successful response for authorized users who are either the creator of the project or included in the project users" do
    get :show, params: { id: project.id }
    expect(response).to have_http_status(:success)
  end

  it "does not allow access for unauthorized users" do
    # Create a new user who is not associated with the project
    unauthorized_user = create(:user)
    sign_in unauthorized_user

    get :show, params: { id: project.id }
    expect(response).to have_http_status(:forbidden)
  end
end


  describe "GET #edit" do
    it "returns a successful response for authorized users" do
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end

    it "does not allow access for unauthorized users" do
      sign_in developer
      get :edit, params: { id: project.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      it "updates the project for authorized users" do
        new_name = "Updated Project Name"
        put :update, params: { id: project.id, project: { name: new_name } }
        project.reload
        expect(project.name).to eq(new_name)
      end

      it "does not update the project for unauthorized users" do
        sign_in developer
        new_name = "Updated Project Name"
        put :update, params: { id: project.id, project: { name: new_name } }
        project.reload
        expect(project.name).not_to eq(new_name)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the project for authorized users" do
      project_to_delete = create(:project, created_by: manager.id)
      expect {
        delete :destroy, params: { id: project_to_delete.id }
      }.to change(Project, :count).by(-1)
    end

    it "does not delete the project for unauthorized users" do
      sign_in developer
      project_to_delete = create(:project, created_by: manager.id)
      expect {
        delete :destroy, params: { id: project_to_delete.id }
      }.not_to change(Project, :count)
    end
  end
end
