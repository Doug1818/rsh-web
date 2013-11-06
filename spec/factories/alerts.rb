# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alert do
    program_id 1
    action_type 1
    streak 1
    sequence 1
  end
end
