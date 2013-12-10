require 'spec_helper'

feature 'a coach creates his practice' do


 scenario 'new user visits sign-up page' do
 	visit root_path
 	click_on 'Sign Up'
 	expect(current_path).to eq(new_practice_path)
 end

 scenario 'new user registers a new practice and coach is created' do
 	coach_counter = Coach.count
 	practice_counter = Practice.count
 	visit new_practice_path
 	fill_in 'Name', with: 'Test'
 	fill_in 'Email', with: 'test@test.com'
 	fill_in 'Password', with: '12345678'
 	fill_in 'Password confirmation', with: '12345678'
 	fill_in 'Card Number', with: '4242424242424242'
 	fill_in 'CVC', with: '123'
 	fill_in 'MM', with: '12'
 	fill_in 'YYYY', with: '2020'
 	click_on 'Create Practice'
 	expect(Practice.count).to eq(practice_counter +1)
 	expect(Coach.count).to eq (coach_counter +1)
 	expect(current_path).to eq(coach_path(Practice.last.coaches.last))
 end
	
end
