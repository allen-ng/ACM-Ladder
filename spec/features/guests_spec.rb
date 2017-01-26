require 'rails_helper'

feature 'Guest features' do
  fixtures :problems
  fixtures :settings

  scenario 'Guest can sign up' do
    visit 'http://localhost:3000/u/sign_up'
    fill_in 'Email', with: 'yoha_test_test_test@acm.nankai.edu.com'
    fill_in 'Handle', with: 'youdonknowthis'
    fill_in 'user_password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'
    click_button 'Sign up'

    expect(page).to have_content('Welcome')
  end
end

