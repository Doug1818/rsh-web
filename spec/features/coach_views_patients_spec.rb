require 'spec_helper'

feature 'coach views list of users' do

	let!(:program1) { FactoryGirl.create(:program) }
	let!(:program2) { FactoryGirl.create(:program, coach: program1.coach) }
	let!(:program3) { FactoryGirl.create(:program, coach: program1.coach) }
	before(:each) { sign_in_as(program1.coach) }
	before(:each) { visit coach_path(program1.coach) }

	it 'displays all users' do
		expect(page).to have_content(program1.user.first_name)
		expect(page).to have_content(program1.user.last_name)
		expect(page).to have_content(program2.user.first_name)
		expect(page).to have_content(program2.user.last_name)
		expect(page).to have_content(program3.user.first_name)
		expect(page).to have_content(program3.user.last_name)
	end

	it 'displays only active users when selected' do
		program1.status = 0
		program1.save
		click_on "Active"
		expect(page).to_not have_content(program1.user.first_name)
		expect(page).to_not have_content(program1.user.last_name)
		expect(page).to have_content(program2.user.first_name)
		expect(page).to have_content(program2.user.last_name)
		expect(page).to have_content(program3.user.first_name)
		expect(page).to have_content(program3.user.last_name)
	end

	it 'displays alerts when selected' do
		FactoryGirl.create(:alert, program: program1)
		click_on 'Alerts'
		expect(page).to have_content(program1.user.first_name)
		expect(page).to have_content(program1.user.last_name)
		expect(page).to_not have_content(program2.user.first_name)
		expect(page).to_not have_content(program2.user.last_name)
		expect(page).to_not have_content(program3.user.first_name)
		expect(page).to_not have_content(program3.user.last_name)
	end

end
