require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "POST #create" do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do
      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, params: { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eql(@user.auth_token)
      end

      it { is_expected.to respond_with(200) }
    end

    context "when the credentials are incorrect" do
      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, params: { session: credentials }
      end

      it "returns a JSON with an error" do
        expect(json_response[:errors]).to eql("Invalid email or password")
      end

      it { is_expected.to respond_with(422) }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      # The sign in helpers accepts no options, it's either the resource or
      # the scope + resource.
      # https://github.com/plataformatec/devise/issues/3532
      sign_in @user
      delete :destroy, params: { id: @user.auth_token }
    end

    it { is_expected.to respond_with 204 }
  end
end
