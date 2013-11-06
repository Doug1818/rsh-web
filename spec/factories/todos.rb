# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    program_id 1
    body "MyText"
    status 1
  end
end
