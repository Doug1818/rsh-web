require 'spec_helper'

feature 'coach signs in and signs out' do

	let!(:coach) { FactoryGirl.create(:coach) }

	scenario 'coach signs in' do
		visit new_coach_session_path
		fill_in 'Email', with: coach.email
		fill_in 'Password', with: coach.password
		within(".form-actions") do
			click_on 'Sign in'
		end
		expect(current_path).to eq(coach_path(coach))
		expect(page).to have_content "Signed in successfully."

	end

	scenario 'coach signs out' do
		sign_in_as(coach)
		visit coach_path(coach)
		click_on 'Sign out'
		expect(current_path).to eq(root_path)
		expect(page).to have_content "Signed out successfully."
	end

end
