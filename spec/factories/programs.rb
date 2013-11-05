# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program do
    coach_id 1
    user_id 1
    state_date "2013-11-04 20:42:11"
    purpose "MyText"
    goal "MyText"
    status 1
  end
end
