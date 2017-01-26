require 'rails_helper'

RSpec.feature 'Show problems', type: :feature do
  fixtures :users
  fixtures :settings
  fixtures :problems

  scenario 'Admin should see all levels and 1001 problem' do
    user = users(:admin)
    user.add_role :admin
    user.remove_role :user
    sign_in(user)
    visit 'problems'
    expect(page).to have_content(settings(:MAX_LEVEL).value)
    click_link('0')
    expect(page).to have_content('A+B Problem')
    expect(page).to have_content('1000')
    sign_out(user)
  end
end
