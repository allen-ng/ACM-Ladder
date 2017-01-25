require "rails_helper"

feature 'user can submit problems' do
  fixtures :users
  fixtures :settings

  background 'user logged in' do
    user = users(:user)
    sign_in user
  end

  # add user submission test

end