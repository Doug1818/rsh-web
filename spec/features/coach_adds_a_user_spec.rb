require 'spec_helper'

feature 'coach adds a new user' do

	let! (:coach) { FactoryGirl.create(:coach) }
	before(:each) { sign_in_as(coach) }

	scenario 'coach enters user info - program and user are created' do
		programs_count = Program.count
		users_count = User.count
		visit new_program_path
		fill_in 'Name', with: 'Test'
		select 'Male', from: 'Gender'
		fill_in 'Email Address', with: 'test@test.com'
		fill_in 'Do what?', with: 'to test'
		fill_in 'So I can...', with: 'test'
		click_on 'Add User'
		expect(current_path).to eql(programs_path)
		expect(page).to have_content "has successfully been added"
		expect(Program.count).to eql(programs_count +1)
		expect(User.count).to eql(users_count +1)
		expect(Program.last.coach_id).to eql(coach.id)
		expect(Program.last.user_id).to eql(User.last.id)
		expect(User.last.email).to eql("test@test.com")
		expect(Program.last.purpose).to eql('to test')
		click_on 'Build Their Plan'
		expect(current_path).to eql(new_big_steps_path(Program.last))
	end

	context 'steps' do

		let!(:program) { FactoryGirl.create(:program, coach: coach) }

		scenario 'coach adds big step' do
			big_steps_count = BigStep.count		
			visit new_big_steps_path(program)
			fill_in 'program[big_steps_attributes][0][name]', with: 'testing'
			click_on 'Next'
			expect(current_path).to eql(new_small_steps_path(program))
			expect(BigStep.count).to eql(big_steps_count +1)
		end

		scenario 'coach adds small step', js: true do
			small_steps_counter = SmallStep.count
			big_step = BigStep.create(name: 'testing', program: program)
			visit new_small_steps_path(program)
			fill_in 'program[weeks_attributes][0][small_steps_attributes][0][name]', with: 'better testing'
			within("#s2id_program_weeks_attributes_0_small_steps_attributes_0_big_step_id") do
				find('.select2-arrow').click
			end
			find(".select2-result-label").click
			within("#s2id_program_weeks_attributes_0_small_steps_attributes_0_frequency") do
				find('.select2-arrow').click
			end
			expect(page).to have_content('Times Per Week')
			within("#s2id_program_weeks_attributes_0_small_steps_attributes_0_frequency") do
				find('.select2-arrow').click
			end
			find('.datepicker').click
			find('.picker__button--today').click
			click_on 'Next'
			expect(current_path).to eql(program_path(program))
			expect(SmallStep.count).to eql(small_steps_counter +1)
		end
	end

end
