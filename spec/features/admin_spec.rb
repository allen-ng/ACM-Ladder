require "rails_helper"

feature '管理员可以管理问题' do
  fixtures :users

  background '管理员已经登录' do
    sign_in users(:admin), scope: :admin
  end

  scenario '管理员可以登录' do

  end
end