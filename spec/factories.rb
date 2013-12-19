FactoryGirl.define do

  factory :coach do
    first_name "Test"
    last_name "Test"
    sequence(:email) {|n| "test#{n}@test.com" }
    password '12345678'
    role 'owner'
    practice
  end

  factory :practice do
    name "Practice Name"
    address "Practice Address"
    state "Practice State"
    city "Practice City"
    zip "12345"
    status 1
    stripe_customer_id "MyString"
    stripe_card_type "MyString"
    stripe_card_last4 "MyString"
  end

  factory :user do
    sequence(:first_name) {|n| "user#{n}" }
    sequence(:last_name) {|n| "patient#{n}" }
    sequence(:email) {|n| "test#{n}@test.com" }
    status 2
  end

  factory :program do
    start_date 1.day.ago
    purpose "MyText"
    goal "MyText"
    authentication_token "MyText"
    status 1
    coach
    user
  end

  factory :big_step do
    name "MyString"
    program
  end

  factory :alert do
    action_type 1
    streak 1
    # sequence 1
    program
  end

end
