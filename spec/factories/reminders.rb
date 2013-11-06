# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reminder do
    program_id 1
    body "MyText"
    frequency 1
    send_at "2013-11-05 22:29:20"
  end
end
