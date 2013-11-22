# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :small_step_activity do
    small_step_id 1
    status 1
    excuse 1
    comments "MyText"
  end
end
