FactoryGirl.define do
  factory :user do
    # Note that there's no colon after a field's name
    email FFaker::Internet.email
    password "12345678"
    password_confirmation "12345678"
  end
end
