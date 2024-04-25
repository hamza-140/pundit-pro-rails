# spec/controllers/projects_controller_spec.rb

require "rails_helper"

RSpec.describe ProjectsController, type: :controller do
  # Include Devise test helpers
  include Devise::Test::ControllerHelpers

  # Devise setup for authentication
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  # Add more specs for other controller actions as needed

  describe "POST #create" do
    it "creates a new project" do
      user = User.create(id: 1, email: "example@example.com", password: "password", password_confirmation: "password", role: "manager")
      project_params = {
        id: 1,
        name: "Custom Project",
        description: "Custom project description",
        created_by: user.id,
      }
      post :create, params: { project: project_params } if user.role == "manager"

      expect(Project.count).to eq(1)
      expect(response).to redirect_to(project_path(1))
    end
  end

  describe "POST #update" do
    it "updates a project" do
      user = User.create(id: 1, email: "example@example.com", password: "password", password_confirmation: "password", role: "manager")
      project = Project.create(id: 1, name: "Original Project Name", description: "Original project description", created_by: user.id)

      project_params = {
        id: 1,
        name: "Updated Project Name",
        description: "Updated project description",
        created_by: user.id,
      }

      if user.role == "manager"
        put :update, params: { id: project.id, project: project_params }

        expect(Project.find(1).name).to eq("Updated Project Name")
        expect(response).to redirect_to(project_path(1))
      else
        expect(user.role).to eq("manager")
        expect(project.created_by).to eq(user.id)
      end
    end
  end
  describe "DELETE #destroy" do
    it "destroys a project" do
      user = User.create(id: 1, email: "example@example.com", password: "password", password_confirmation: "password", role: "manager")
      project = Project.create(id: 1, name: "Sample Project", description: "Sample project description", created_by: user.id)

      if user.role == "manager"
        delete :destroy, params: { id: project.id }

        expect(Project.exists?(project.id)).to be_falsey
        expect(response).to redirect_to(projects_path)
      else
        expect(user.role).to eq("manager")
        expect(Project.exists?(project.id)).to be_truthy
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user = User.create(id: 1, email: "example@example.com", password: "password", password_confirmation: "password", role: "manager")
      user2 = User.create(id: 2, email: "example@example.com", password: "password", password_confirmation: "password", role: "developer")
      project = Project.create(name: "Custom Project", description: "Custom project description", created_by: user.id)

      get :show, params: { id: project.id }
      if project.created_by == user.id || project.users.include?(user)
        expect(response).to be_successful
      else
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
