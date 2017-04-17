require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers["Accept"] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      #get :show, params: { id: @user.id }, format: :json
      get :show, params: { id: @user.id, format: :json }
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql(@user.email)
    end

    it { is_expected.to respond_with 200 }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes, format: :json }
      end

      it "renders the JSON representation for the user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql(@user_attributes[:email])
      end

      it { is_expected.to respond_with(201) } # Created
    end

    context "when is not created" do
      before(:each) do
        # Notice that email is not included
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, params: { user: @invalid_user_attributes, format: :json }
      end

      it "renders an errors JSON" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the JSON errors on why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it { is_expected.to respond_with(422) } # Unprocessable Entity
    end
  end

  describe "PUT/PATCH #update" do
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, params: { id: @user.id, user: { email: "newmail@example.com" }, format: :json }
      end

      it "renders the JSON representation for the updated user" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql("newmail@example.com")
      end

      it { is_expected.to respond_with(200) } # OK
    end

    context "when is not updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, params: { id: @user.id, user: { email: "badmail.com" }, format: :json }
      end

      it "renders an errors JSON" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the JSON errors on why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("is invalid")
      end

      it { is_expected.to respond_with(422) } # Unprocessable Entity
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, params: { id: @user.id, format: :json }
    end

    it { is_expected.to respond_with(204) } # No Content
  end
end
