require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:manager) { create(:user, role: "manager") }

  describe "GET #show" do
    let(:project) { create(:project, created_by: user.id) }

    it "returns a successful response for the creator or users associated with the project" do
      sign_in user
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:success)
    end

    it "does not allow access for unauthorized users" do
      sign_in create(:user)
      get :show, params: { id: project.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  # describe "GET #edit" do
  #   let(:project) { create(:project, created_by: manager.id) }

  #   it "returns a successful response if the user is the creator of the project" do
  #     sign_in manager
  #     get :edit, params: { id: project.id }
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "does not allow access for unauthorized users" do
  #     sign_in user
  #     get :edit, params: { id: project.id }
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end

  # describe "POST #create" do
  #   it "allows managers to create projects" do
  #     sign_in manager
  #     expect {
  #       post :create, params: { project: attributes_for(:project, created_by: manager.id) }
  #     }.to change(Project, :count).by(1)
  #     expect(response).to have_http_status(:redirect)
  #   end

  #   it "does not allow unauthorized users to create projects" do
  #     sign_in user
  #     expect {
  #       post :create, params: { project: attributes_for(:project, created_by: user.id) }
  #     }.to_not change(Project, :count)
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end

  # describe "DELETE #destroy" do
  #   let!(:project) { create(:project, created_by: manager.id) }

  #   it "allows the creator to delete the project" do
  #     sign_in manager
  #     expect {
  #       delete :destroy, params: { id: project.id }
  #     }.to change(Project, :count).by(-1)
  #   end

  #   it "does not allow access for unauthorized users" do
  #     sign_in user
  #     expect {
  #       delete :destroy, params: { id: project.id }
  #     }.to_not change(Project, :count)
  #     expect(response).to have_http_status(:forbidden)
  #   end
  # end
end
