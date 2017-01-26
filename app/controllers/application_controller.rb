class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :check_level_up
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :new && exception.subject.class == Submission
      redirect_to new_user_session_path, :alert => "You need to sign in or sign up before continuing."
    else
      redirect_to root_path, :alert => exception.message
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:level] = current_user.level
    super
  end

  protected

  # After rails 4, strong parameters are moved to controller
  # This is responsible for permitting additional parameters
  # Also, this function is added on top of this file in before_action
  # As is stated in https://github.com/plataformatec/devise section strong parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :handle, :school, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :handle, :school, :current_password, :password, :password_confirmation)
    end
  end

  private

  def check_level_up
    if user_signed_in?
      session[:level] ||= current_user.level
      if current_user.level > session[:level]
        flash[:info] = "Congratulations! You got level up!"
        session[:level] = current_user.level
      end
    end
  end
end
