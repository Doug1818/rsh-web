FactoryGirl.define do

  factory :coach do
    practice_id 1
    first_name "Test"
    last_name "Test"
    email "test@test.com"
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

end
