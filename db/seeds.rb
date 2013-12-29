# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

db_tables = %w{ practices coaches users programs weeks small_steps_weeks big_steps small_steps excuses check_ins activities check_ins_excuses alerts reminders }
db_tables.each {|db_table| ActiveRecord::Base.connection.execute("TRUNCATE #{ db_table }") }

class Seed

  def initialize(options = {})
    @program_count = options[:program_count] || 8
    @coaches = options[:coaches]

    @big_steps = ['Flexibility', 'Strength', 'Nutrition']
  end

  def run
    # Practices and Coaches
    @coaches.each do |coach|
      new_practice do |practice|

        @coach = @practice.coaches.create(coach)
        @coach.password = 'test123test'
        @coach.password_confirmation = 'test123test'
        @coach.save!

         @program_count.times do
          new_program do |program|
            new_user do |user|
              user = program.build_user(user)
              user.save!
            end
            program.coach_id = @coach.id
            program.save!

            start_date = program.start_date.in_time_zone("America/New_York").beginning_of_week(:sunday)
            end_date = program.start_date.in_time_zone("America/New_York").end_of_week(:sunday)
            program.weeks.create(start_date: start_date, end_date: end_date, number: 1)

            @big_steps.each_with_index do |big_step_name, index|
              @big_step = program.big_steps.create(name: big_step_name)

              # Create an array of Small Step names appropriately named based on the Big Step name
              @small_step_name = get_small_step_name(big_step_name)

              next_start_date = program.weeks.last.start_date + 1.week
              next_end_date = program.weeks.last.end_date + 1.week
              week_number = index + 1

              # Use the first week if this is our first time through; otherwise, create a new week
              @week = index == 0 ? program.weeks.first : program.weeks.create(start_date: next_start_date, end_date: next_end_date, number: week_number)

              @frequencies = SmallStep::FREQUENCIES

              0.upto(6) do |i|

                frequency_value = if i < 3
                  @frequencies.values[0]
                elsif (i >= 3 and i < 5)
                  @frequencies.values[1]
                else
                  @frequencies.values[2]
                end

                frequency_name = @frequencies.keys[frequency_value]

                small_step = {
                  name: @small_step_name[i],
                  program_id: program.id,
                  frequency: frequency_value
                }

                case frequency_name
                when 'Times Per Week'
                  small_step[:times_per_week] = 4
                when 'Specific Days'
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
      end
    end
  end

  # Create check-ins for the first Program of each Practice
  def checkins
    @practices = Practice.all
    @practices.each do |practice|

      puts "\nPractice: #{ practice.name }"
      @programs = practice.programs

      @programs.each do |program|

        puts "\n#{ program.user.first_name }'s Program"

        start_date = program.start_date
        end_date = 2.days.ago.in_time_zone("America/New_York").to_date

        (start_date..end_date).each do |day|
          @small_steps = program.small_steps.includes(:weeks).where("DATE(?) BETWEEN weeks.start_date AND weeks.end_date", day).references(:weeks)

          # Create a check in for the day
          comments = "Checking in for #{ day }"
          @check_in = CheckIn.create(comments: comments, created_at: day)
          puts "\n#{ comments }"

          # Mark each of the small steps for the check in
          @small_steps.each_with_index do |small_step, i|

            # Mark all if it's Monday or Tuesday
            # Mark none if it's Wednesday or Thursday
            # Mark individually otherwise
              # No if the current iteration is even, yes if it is odd
            status = if (day.monday? or day.wednesday?)
              1
            elsif (day.tuesday? or day.thursday?)
              0
            else
              i.even? ? 0 : 1
            end

            puts "Small Step: #{ small_step.name }, Status: #{ status }\n"

            if status == 0 and i.odd? # Give an excuse for every other one marked as did not do
              excuse_name = "This is my excuse"
              @excuse = practice.excuses.find_or_create_by name: excuse_name
              @check_in.excuses << @excuse
            end

            week = program.weeks.where("DATE(?) BETWEEN start_date AND end_date", day).first

            # @check_in.small_step_id = small_step.id
            @check_in.week_id = week.id
            @check_in.activities.create(small_step_id: small_step.id, status: status, created_at: day)
            @check_in.save!
          end
        end
      end
    end
  end

  private

  def new_practice
    practice = {
      name: Faker::Company.name,
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zip: Faker::Address.zip_code,
      status: 1
    }
    @practice = Practice.create(practice)
    @practice.save!

    yield @practice
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
      purpose: ["heal my hip", "recover from back surgery", "improve my quality of life"].sample,
      goal: ["get jiggy with it", "run the next 10k race", "spend more time with my kids"].sample,
      status: 1,
      start_date: 2.weeks.ago.beginning_of_week(:sunday)
    }
    @program = Program.new(program)
    yield @program
  end

  def get_small_step_name(big_step_name)
    case big_step_name
    when 'Flexibility'
      ['stretch for 10 minutes', 'jog around the block', 'do a cartwheel', 'fly a kite', 'do 20 jumping jacks', 'play tennis for 30 minutes', 'practice martial arts']
    when 'Strength'
      ['do 3 sets of bench presses', 'curl a 30 lb dumbbell', 'do 20 push ups', 'do 3 sets of 10 squats', 'lift a car', '20 minutes of circuit training', 'do a 200 lb dead-lift']
    when 'Nutrition'
      ['eat 2 vegetables per day', 'drink a protein shake', 'eat fish', 'eat a piece of fruit', 'take vitamins', 'eat green leafy vegetables', 'count your calories']
    else
      []
    end
  end
end

# Add owners here to create new test Owners and Practices
owners = [{
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
},{
  first_name: 'Rick',
  last_name: 'McMullen',
  email: 'roderick.mcmullen@gmail.com',
  gender: 'Male',
  status: 1,
  role: 'owner'
},{
  first_name: 'Doug',
  last_name: 'Raicek',
  email: 'doug.raicek@gmail.com',
  gender: 'Male',
  status: 1,
  role: 'owner'
},{
  first_name: 'Josh',
  last_name: 'Boehringer',
  email: 'joshadelic@gmail.com',
  gender: 'Male',
  status: 1,
  role: 'owner'
},{
  first_name: 'Jon',
  last_name: 'Rish',
  email: 'jon@barbershoplabs.com',
  gender: 'Male',
  status: 1,
  role: 'owner'
}]

seed = Seed.new(coaches: owners, program_count: 8) # Change the program_count to specify how many Programs each Practice should have.
seed.run
seed.checkins




