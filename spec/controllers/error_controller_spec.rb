require 'rails_helper'

RSpec.describe ErrorController, type: :controller do

  describe "GET #forbidden" do
    it "returns http success" do
      get :forbidden
      expect(response).to have_http_status(:success)
    end
  end

end
