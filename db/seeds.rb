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
ActiveRecord::Base.connection.execute("TRUNCATE big_steps")
ActiveRecord::Base.connection.execute("TRUNCATE small_steps")
ActiveRecord::Base.connection.execute("TRUNCATE excuses")
ActiveRecord::Base.connection.execute("TRUNCATE check_ins")
ActiveRecord::Base.connection.execute("TRUNCATE activities")
ActiveRecord::Base.connection.execute("TRUNCATE check_ins_excuses")

def create_coach(options = {})
  role = options[:role] || 'coach'
  practice_id = options[:practice_id] || Practice.pluck(:id).sample
  first_name = options[:first_name] || Faker::Name.first_name
  last_name = options[:last_name] || Faker::Name.last_name
  email = options[:email] || Faker::Internet.email
  gender = options[:gender] || Coach::GENDERS.sample

  coach = {
    practice_id: practice_id,
    role: role,
    first_name: first_name,
    last_name: last_name,
    email: email,
    gender: gender,
    avatar: nil,
    status: 1
  }
  coach = Coach.create(coach)
  coach.password = 'testing123'
  coach.password_confirmation = 'testing123'
  coach.save!
end

def create_user_and_program(coach_id)
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


# START HERE

# Create 2 Practices
2.times do
  practice = {
    name: Faker::Company.name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip_code,
    status: 1
  }
  Practice.create(practice)
end

# Set the Owners of the Practices
create_coach(role: 'owner', practice_id: Practice.first.id, first_name: 'Adam', last_name: 'Rubin', email: 'adam@barbershoplabs.com', gender: 'Male')
create_coach(role: 'owner', practice_id: Practice.last.id, first_name: 'Nate', last_name: 'Prouty', email: 'nate@barbershoplabs.com', gender: 'Male')
 
# Create 10 Coaches at random Practices and give them some users
10.times do
  create_coach
end

# Give each Coach (including Owners) 8 Users
Coach.all.each do |coach|
   8.times do
    create_user_and_program(coach.id)
  end
end

# Big steps
Program.all.each do |program|
  big_step_name = ['Flexibility', 'Strength', 'Nutrition'].sample
  BigStep.create({ program_id: program.id, name: big_step_name })
end

# Small steps
BigStep.all.each do |big_step|
  # Create between 1 and 10 small steps
  1.upto((2..10).to_a.sample) do |i|
    frequency = SmallStep::FREQUENCIES.keys.sample

    small_step_name = case big_step.name
    when 'Flexibility' then ['do stretches', 'do toe touches', 'do cartwheels'].sample
    when 'Strength' then ['do 3 sets of dead lifts', 'do 10 push ups', 'do 4 sets of barbell raises', 'do 3 sets of shoulder presses'].sample
    when 'Nutrition' then ['eat a carrot', 'eat more fruit', 'eat green vegetables', 'drink more water', 'eat fewer calories'].sample
    else
    end
    
    week_number = i > 2 ? 2 : 1 # Put the first two small steps in week 1, the remaining in week 2

    small_step = {
      name: small_step_name,
      week_number: week_number,
      frequency: SmallStep::FREQUENCIES[frequency],
      program_id: big_step.program.id,
      days: (1..20).to_a.sample
    }

    # Determine which other columns to set based on the frequency
    case frequency
    when '# Times Per Week'
      small_step[:times_per_week] = (1..7).to_a.sample
    when 'Specific Days of the Week'
      small_step[:sunday] = true # make at least one day true
      ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'].each do |day|
        small_step[day.to_sym] = [true,false].sample
      end
    else
    end
    @small_step = SmallStep.create(small_step)
    big_step.small_steps << @small_step
  end
end

# Check-ins
SmallStep.all.each_with_index do |small_step, index|
  # Check in every 5 small steps
  if index % 5 == 0
    comments = Faker::Lorem.paragraph
    check_in = CheckIn.create({ comments: comments })

    # For each small step that week, create an Activity
    SmallStep.where(big_step_id: small_step.big_step_id, week_number: small_step.week_number).each do |ss|
      activity = Activity.create({small_step_id: ss.id, status: [0,1].sample })
      check_in.activities << activity
    end
    small_step.check_ins << check_in
  end
end

# Excuses
Activity.where(status: 0).each_with_index do |activity, index|
  # Give every other check in that has an activity status of 0 an excuse
  if index % 2 == 0
    check_in = activity.check_in

    excuse = Excuse.create({ name: Excuse::GLOBAL_EXCUSES.sample })
    excuse.practice = check_in.small_step.program.coach.practice
    excuse.save!

    check_in.excuses << excuse
    check_in.save!
  end
end

