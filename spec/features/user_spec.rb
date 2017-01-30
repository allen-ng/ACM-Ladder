require "rails_helper"

feature 'user can submit problems' do
  fixtures :users
  fixtures :settings
  fixtures :problems

  background 'user logged in' do
    user = users(:user)
    user.add_role :user
    sign_in user
  end

  # add user submission test
  scenario 'user can submit solution' do
    visit problem_path(Problem.all()[0])
    choose('C++ (g++)')
    fill_in 'Code', with: <<~CPPCODE
      #include <iostream>
      using namespace std;
      int main()
      {
          int a,b;
          cin >> a >> b;
          cout << a+b << endl;
          return 0;
      }
    CPPCODE
    click_button('submit-code')
    visit user_submissions_path(users(:user))
    expect(page).to have_content(users(:user).handle)
  end

end