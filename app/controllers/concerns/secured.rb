module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticate_user!
    max_session_time = ENV['MAX_SESSION_TIME'].to_i || 0
    session_valid = max_session_time === 0 ||
        (session[:last_access_time] &&
            (Time.now - session[:last_access_time].to_datetime).to_f / 60 < max_session_time)

    if current_user.nil?
      session.delete(:user_id)
      session.delete(:last_access_time)
      redirect_to login_path, flash: {danger: 'Your must be logged in to access this page'}
    elsif !session_valid
      if request.format == 'application/json'
        (render json: {success: false, message: 'Your session has expired.'}, status: 440)
      else
        session.delete(:user_id)
        session.delete(:last_access_time)
        (redirect_to login_path, flash: {danger: 'Your session has expired.'})
      end
    else
      session[:last_access_time] = Time.now.to_s
    end
  end

  def validate_user_role!(role)
    redirect_to forbidden_path unless current_user != nil && current_user.has_role?(role)
  end

  # Accepts array of roles for validation
  def validate_user_roles!(roles)
    redirect_to forbidden_path unless current_user != nil && roles.any? {|role| current_user.has_role?(role)}
  end
end
