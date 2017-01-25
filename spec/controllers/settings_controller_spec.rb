require 'rails_helper'

RSpec.describe SettingsController, type: :controller do

  fixtures :users
  fixtures :settings
  # Login admin
  before(:each) do
    user = users(:admin)
    user.add_role :admin
    user.remove_role :user
    sign_in user
  end

  describe 'update settings' do

    it 'update max_level and max_difficulty' do
      put :update, params: { setting: {
          max_level: 3,
          max_difficulty: 5
        }
      }
      expect(Setting.find_by(key: 'MAX_LEVEL').value).to eq('3')
      expect(Setting.find_by(key: 'MAX_DIFFICULTY').value).to eq('5')

      put :update, params: { setting: {
          max_level: 6,
          max_difficulty: 2
        }
      }
      expect(Setting.find_by(key: 'MAX_LEVEL').value).to eq('6')
      expect(Setting.find_by(key: 'MAX_DIFFICULTY').value).to eq('2')
    end
  end

end
