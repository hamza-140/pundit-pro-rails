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

  describe "PUT #update" do
    context "with valid parameters" do
      it "updates the bug" do
        new_title = "Updated Bug Title"
        put :update, params: { project_id: project.id, id: bug.id, bug: { title: new_title } }
        bug.reload
        expect(bug.title).to eq(new_title)
      end
    end

    context "with invalid parameters" do
      it "does not update the bug" do
        put :update, params: { project_id: project.id, id: bug.id, bug: { title: "" } }
        bug.reload
        expect(bug.title).not_to be_blank
      end
    end
  end
end
