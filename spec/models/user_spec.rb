require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  # is_expected is defined simply as expect(subject) and is designed for
  # when you are using rspec-expectations with its newer expect-based syntax.
  # https://relishapp.com/rspec/rspec-core/docs/subject/one-liner-syntax
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:auth_token) }

  it { is_expected.to be_valid }

  # shoulda-matchers help us write simpler tests using validate_xxxxx_of,
  # allow_value, and others.
  # https://github.com/thoughtbot/shoulda-matchers
  it { is_expected.to validate_presence_of(:email) }
  # validate_uniqueness_of uses the lowercase and uppercase of the same email
  # address. However Devise converts email addresses to lowercase before
  # stroing them to users table. Hence using ignoring_case_sensitivity as a
  # workaround.
  # https://github.com/thoughtbot/shoulda-matchers/issues/935
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value("example@domain.com").for(:email) }

  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      #Devise.stub(:friendly_token).and_return("auniquetoken123")
      #allow_any_instance_of(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql("auniquetoken123")
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql(existing_user.auth_token)
    end
  end
end
