# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :practice do
    name "MyString"
    address "MyString"
    state "MyString"
    city "MyString"
    zip "MyString"
    status 1
    stripe_customer_id "MyString"
    stripe_card_type "MyString"
    stripe_card_last4 "MyString"
  end
end
