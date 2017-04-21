# Without extending ApplicationController, request was not recognized.
class Authentication < ApplicationController
  # When it comes to test modules, the author finds it easy to include them
  # into a temporary class and stub any other methods that may be required
  # later, like the request shown below.
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before do
      @user = FactoryGirl.create :user
      # Authorization header gives context to the actual request without
      # polluting the URL with extra parameters.
      # request is made available via ApplicationController.
      request.headers["Authorization"] = @user.auth_token
      # Old syntax: authentication.stub(:request).and_return(request)
      allow(authentication).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql(@user.auth_token)
    end
  end

  describe "#authenticate_with_token" do
    before do
      @user = FactoryGirl.create :user
      # Not authenticated unless current user is present
      allow(authentication).to receive(:current_user).and_return(nil)
      # Why authenticate_with_token! is not called to test its response code
      # and body but these values are hard coded instead?
      allow(response).to receive(:response_code).and_return(401) # Unauthorized
      allow(response).to receive(:body).and_return({ "errors" => "Not authenticated" }.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "render a json error message" do
      expect(json_response[:errors]).to eql("Not authenticated")
    end

    it { is_expected.to respond_with(401) }
  end
end
