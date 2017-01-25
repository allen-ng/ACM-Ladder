class SettingsController < ApplicationController
  authorize_resource

  def update
    errors = 0
    errors += 1 unless update_int("MAX_LEVEL", params[:setting][:max_level], "Kidding? The level you tell me is not a number!")
    errors += 1 unless update_int("MAX_DIFFICULTY", params[:setting][:max_difficulty], "Kidding? The difficulty you tell me is not a number!")

    setting = Setting.find_by_key("SHOW_ANNOUNCEMENT")
    setting.value = params[:setting][:show_announcement]
    setting.save
    if Setting.where(:key => "ANNOUNCEMENT").last.value != params[:setting][:announcement]
      Setting.new(:key => "ANNOUNCEMENT", :value => params[:setting][:announcement]).save
    end

    if errors == 0
      redirect_to edit_setting_path, :notice => "Update settings successfully!"
    else
      render :action => :edit
    end
  end

  private
  def update_int(key, value, error_msg)
    unless value.blank?
      begin
        value = Integer(value)
        setting = Setting.find_by_key(key)
        setting.value = value
        setting.save
        # Setting.find_by_key(key) { |s| s.value = value }.save
        (value + 1).times { |level| Setting.find_or_create_by(:key => "EXP_L#{level}", :value => 0) } if key == "MAX_LEVEL"
      rescue ArgumentError
        flash[:"alert_#{key.downcase}"] = error_msg
        return false
      end
    end

    true
  end
end
