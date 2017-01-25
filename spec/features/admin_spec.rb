require "rails_helper"

feature '管理员可以管理问题' do
  fixtures :users
  fixtures :settings

  background '管理员已经登录' do
    user = users(:admin)
    user.add_role :admin
    user.remove_role :user
    sign_in user
  end

  scenario '管理员可以增加poj题目' do
    visit '/problems/new'
    select("POJ", from: "Source")
  end

  pending '管理员可以增加codeforces题目' do
    visit '/problems/new'
    select("Codeforces", from: "Source")
  end
end