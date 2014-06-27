FactoryGirl.define do
  factory :user do
    name "Michael";
    email "michael@mail.com";
    password "password1";
    password_confirmation "password1";
  end
end
