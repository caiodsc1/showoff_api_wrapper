# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user
  before_action :set_token, only: %i[update show_logged_in_user change_password reset_password get_private_widgets]

  def create
    @user.new_record = true

    if @user.save
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def update
    @user.id = params[:id]
    @user.new_record = false

    if @user.save
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def show_logged_in_user
    if @user.show_logged_in_user
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def show_user_id
    @user.id = params[:id]

    if @user.show_user_id
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def change_password
    if @user.change_password
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def reset_password
    if @user.reset_password
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def check_email
    if @user.check_email
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def get_private_widgets
    search_term = params.dig('user', 'widgets', 'search_term')

    if @user.get_private_widgets(search_term: search_term)
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def get_widgets_by_user_id
    @user.id = params[:id]
    search_term = params.dig('user', 'widgets', 'search_term')

    if @user.get_widgets_by_user_id(search_term: search_term)
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.new(user_params)
  end

  def set_token
    @user.token = session[:token] if @user.token.nil?
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email,
                                 :first_name,
                                 :last_name,
                                 :password,
                                 :current_password,
                                 :new_password,
                                 :date_of_birth,
                                 :image_url,
                                 :token,
                                 widgets: [:search_term])
  end
end
