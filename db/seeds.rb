# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Wipe the current data
ActiveRecord::Base.connection.execute("TRUNCATE practices")
ActiveRecord::Base.connection.execute("TRUNCATE coaches")
ActiveRecord::Base.connection.execute("TRUNCATE users")
ActiveRecord::Base.connection.execute("TRUNCATE programs")

def create_coach(options = {})
  role = options[:role] || 'coach'
  practice_id = options[:practice_id] || Practice.first.id

  coach = {
    practice_id: practice_id,
    role: role,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    gender: Coach::GENDERS.sample,
    avatar: nil,
    status: 1
  }
  coach = Coach.create(coach)
  coach.password = 'testing123'
  coach.password_confirmation = 'testing123'
  coach.save!
end

def create_users_and_programs(coach_id)
  8.times do
    user = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      status: 1,
      gender: User::GENDERS.sample,
      avatar: nil
    }
    user = User.create(user)
    user.password = 'testing123'
    user.password_confirmation = 'testing123'
    user.save!

    program = {
      coach_id: coach_id,
      user_id: User.last.id,
      purpose: ["To improve flexibility", "To improve strength", "To help with my hip"].sample,
      status: 1,
      start_date: Date.today #+ [*0..5].sample # Start some day between now and in 5 days
    }
    Program.create(program)
  end
end

# Create 2 Practices and their Owners (Coaches)
# Give each Owner some Users
2.times do
  practice = {
    name: Faker::Company.name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip_code,
    status: 1
  }
  practice = Practice.create(practice)
  create_coach(role: 'owner', practice_id: practice.id)
  create_users_and_programs(Coach.last.id)
end

# Create 10 Coaches at random Practices and give them some users
10.times do
  create_coach(role: 'coach', practice_id: Practice.pluck(:id).sample)
  create_users_and_programs(Coach.last.id)
end




