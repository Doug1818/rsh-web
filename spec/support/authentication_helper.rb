module AuthenticationHelper
  def sign_in_as(user)
    visit new_coach_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
end
