class ApplicationController < ActionController::Base
  helper_method :user_authenticated?

  def user_authenticated?
    session[:token].present?
  end
end
