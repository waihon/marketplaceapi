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

  it { is_expected.to be_valid }
end
