FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "user #{n}"}
    sequence(:email){|n| "user#{n}@exmpl.dom"}
    password "password"
    password_confirmation "password"
      
      factory :admin do
        admin true 
      end
    end
    
    factory :micropost do
      content  "Simple msg"
      user
    end
    factory :hashtag do
      text "smp_tag"
    end
end
