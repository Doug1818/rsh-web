# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :small_step do
    big_step_id 1
    name "MyString"
    priority 1
    length 1
    frequency 1
    times_per_week 1
    sunday false
    monday false
    tuesday false
    wednesday false
    thursday false
    friday false
    saturday false
  end
end
