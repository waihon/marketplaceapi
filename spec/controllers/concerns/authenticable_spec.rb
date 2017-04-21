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
end
