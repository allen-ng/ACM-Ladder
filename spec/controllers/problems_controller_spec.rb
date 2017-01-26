require 'rails_helper'

RSpec.describe ProblemsController, type: :controller do
  fixtures :users
  fixtures :settings
  fixtures :problems
  # Login admin
  before(:each) do
    user = users(:admin)
    user.add_role :admin
    user.remove_role :user
    sign_in user
  end
end
