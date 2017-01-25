require "rails_helper"

feature 'administrator can manage problems' do
  fixtures :users
  fixtures :settings

  background 'administrator logged in' do
    user = users(:admin)
    user.add_role :admin
    user.remove_role :user
    sign_in user
  end

  scenario 'administrator can add poj problem' do
    visit '/problems/new'
    select("POJ", from: "Source")
  end

  pending 'administrator can add codeforces problem' do
    visit '/problems/new'
    select("Codeforces", from: "Source")
  end
end