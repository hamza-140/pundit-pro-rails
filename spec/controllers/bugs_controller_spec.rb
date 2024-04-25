require "rails_helper"

RSpec.describe BugsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:project) { create(:project, created_by: user.id) }
  let(:bug) { create(:bug, project: project, user: user, created_by: user.id) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index, params: { project_id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "creates a new bug" do
      custom_user = create(:user, role: ["manager", "quality_assurance"].sample)

      custom_project = create(:project, created_by: custom_user.id)
      bug_params = attributes_for(:bug, project_id: custom_project.id)

      expect {
        post :create, params: { project_id: custom_project.id, bug: bug_params }
      }.to change(Bug, :count).by(1)

      expect(custom_user.role).to eq("manager").or(eq("quality_assurance"))

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      it "updates the bug" do
        new_title = "Updated Bug Title"
        put :update, params: { project_id: project.id, id: bug.id, bug: { title: new_title } }
        bug.reload
        expect(bug.title).to eq(new_title)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "with invalid parameters" do
      it "does not update the bug" do
        put :update, params: { project_id: project.id, id: bug.id, bug: { title: "" } }
        bug.reload
        expect(bug.title).not_to be_blank
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys a bug" do
      custom_user = User.create(id: 1, email: "custom@example.com", password: "password", password_confirmation: "password", role: "manager")
      custom_project = Project.create(id: 1, name: "Custom Project", description: "Custom project description", created_by: custom_user.id)
      custom_bug = Bug.create(id: 1, title: "Custom Bug", description: "Custom bug description", user_id: custom_user.id, project_id: custom_project.id, created_by: custom_user.id)
      if custom_bug.created_by == custom_user.id
        delete :destroy, params: { project_id: custom_project.id, id: custom_bug.id }
        expect(Bug.exists?(custom_bug.id)).to be_falsey
        expect(response).to have_http_status(:redirect)
      else
        expect(custom_bug.created_by).to eq(custom_user.id)
      end
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { project_id: project.id, id: bug.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new, params: { project_id: project.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { project_id: project.id, id: bug.id }
      expect(response).to have_http_status(:success)
    end
  end
end
