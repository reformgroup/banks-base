FactoryGirl.define do
  
  factory :user do
    
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    birth_date { 18.years.ago - Faker::Number.number(3).to_i.days }
    gender "male"
    password "foobar"
    password_confirmation "foobar"
    role "user"
    avatar { process_uri(Faker::Avatar.image) }
    
    factory :admin do
      role "admin"
    end
    
    factory :bank_user do
      role "bank_user"
    end
    
    factory :me do
      first_name "Foo"
      last_name "Bar"
      email "test@mail.com"
      birth_date { 18.years.ago - Faker::Number.number(3).to_i.days }
      gender "male"
      password "123123"
      password_confirmation "123123"
      role "admin"
      avatar { process_uri(Faker::Avatar.image) }
    end
  end
  
  factory :bank do
    
    name { Faker::Company.name }
    short_name "MEB"
    website "foobar.com"
    
    factory :bank_with_users do
      
      transient { users_count 1 }
      
      after(:build) do |bank, evaluator|
        bank.users << build_list(:bank_user, evaluator.users_count)
        bank
      end
    end
  end
end