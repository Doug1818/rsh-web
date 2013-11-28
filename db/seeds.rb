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
ActiveRecord::Base.connection.execute("TRUNCATE weeks")
ActiveRecord::Base.connection.execute("TRUNCATE small_steps_weeks")
ActiveRecord::Base.connection.execute("TRUNCATE big_steps")
ActiveRecord::Base.connection.execute("TRUNCATE small_steps")
ActiveRecord::Base.connection.execute("TRUNCATE excuses")
ActiveRecord::Base.connection.execute("TRUNCATE check_ins")
ActiveRecord::Base.connection.execute("TRUNCATE activities")
ActiveRecord::Base.connection.execute("TRUNCATE check_ins_excuses")


def new_practice
  practice = {
    name: Faker::Company.name,
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip_code,
    status: 1
  }
  yield practice
end

def new_user
  user = {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    status: 1,
    gender: User::GENDERS.sample,
    avatar: nil
  }
  yield user
end

def new_program
  program = {
    purpose: ["To improve flexibility", "To improve strength", "To help with my hip"].sample,
    status: 1,
    start_date: 2.weeks.ago
  }
  @program = Program.new(program)
  yield @program
end

coaches = [{
  first_name: 'Nate',
  last_name: 'Prouty',
  email: 'nate@barbershoplabs.com',
  gender: 'Male',
  status: 1,
  role: 'owner'
},{
  first_name: 'Adam',
  last_name: 'Rubin',
  email: 'adam@barbershoplabs.com',
  gender: 'Male',
  status: 1,
  role: 'owner'
}]

# Practices and Coaches
0.upto(1) do |i|
  new_practice do |practice| 
    @practice = Practice.create(practice)
    @practice.save!

    @coach = @practice.coaches.create(coaches[i])
    @coach.password = 'test123test'
    @coach.password_confirmation = 'test123test'
    @coach.save!
  end
end

# Users and Programs

Coach.all.each do |coach|
  @practice = coach.practice

  8.times do
    new_program do |program|
      new_user do |user|
        user = program.build_user(user)
        user.save!
      end
      program.coach_id = coach.id
      program.save!
      program.weeks.create(start_date: program.start_date.beginning_of_week(:sunday), end_date: program.start_date.end_of_week(:sunday), number: 1)
    end
  end


  # Big Steps
  @practice.programs.all.each do |program|
    ['Flexibility', 'Strength', 'Nutrition'].each_with_index do |big_step_name, index|
      @big_step = program.big_steps.create(name: big_step_name)

      # Create an array of Small Step names appropriately named based on the Big Step name
      @small_step_name = case big_step_name
      when 'Flexibility'
        ['stretch for 10 minutes', 'jog around the block', 'do a cartwheel']
      when 'Strength'
        ['do 3 sets of bench presses', 'curl a 30 lb dumbbell', 'do 20 push ups']
      when 'Nutrition'
        ['eat 2 vegetables per day', 'drink a protein shake', 'eat fish']
      else
        []
      end

      next_start_date = program.weeks.last.start_date + 1.week
      next_end_date = program.weeks.last.end_date + 1.week
      week_number = index + 1

      # Use the first week if this is our first time through; otherwise, create a new week
      @week = index == 0 ? program.weeks.first : program.weeks.create(start_date: next_start_date, end_date: next_end_date, number: week_number)

      SmallStep::FREQUENCIES.keys.each_with_index do |frequency, i|
        small_step = {
          name: @small_step_name[i],
          frequency: SmallStep::FREQUENCIES[frequency],
          program_id: program.id,
        }

        case frequency
        when '# Times Per Week'
          small_step[:times_per_week] = 4
        when 'Specific Days of the Week'
          small_step[:monday] = true 
          small_step[:wednesday] = true
          small_step[:friday] = true
        end
        
        @small_step = @week.small_steps.create(small_step)
        @big_step.small_steps << @small_step
      end
    end
  end
end