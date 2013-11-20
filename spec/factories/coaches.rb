# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coach do
    practice_id 1
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    gender "MyString"
    avatar "MyString"
    invite_token "MyString"
    status 1
  end
end
