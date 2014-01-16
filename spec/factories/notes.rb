# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    small_step_id 1
    body "MyText"
  end
end
