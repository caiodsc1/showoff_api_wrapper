# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, :set_tokens

  def create
    @user.new_record = true

    if @user.save
      session[:token] = @user.response.dig('data', 'token', 'access_token')
      session[:refresh_token] = @user.response.dig('data', 'token', 'refresh_token')
      session[:user_email] = @user.email

      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @user.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
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

  def show_authenticated_user
    if @user.show_authenticated_user
      @user.reload

      respond_to do |format|
        format.html
        format.json { render json: @user.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
    end
  end

  def show_user_by_id
    @user.id = params[:id]

    if @user.show_user_by_id
      @user.reload

      respond_to do |format|
        format.html
        format.json { render json: @user.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
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
    @user.email = session[:user_email]

    if @user.reset_password
      respond_to do |format|
        format.html do
          flash[:notice] = @user.response['message']
          redirect_back fallback_location: root_path
        end
        format.json { render json: @user.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
    end
  end

  def check_email
    if @user.check_email
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def private_widgets
    search_term = params[:search_term]

    if @user.private_widgets(search_term)
      respond_to do |format|
        format.html do
          @widgets = helpers.prepare_for_collection(@user, Widget)
        end
        format.json { render json: @user.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
    end
  end

  def widgets_by_user_id
    @user.id = params[:id]
    search_term = params[:search_term]

    if @user.widgets_by_user_id(search_term)
      render json: @user.response, status: :ok
    else
      render json: @user.errors, status: :conflict
    end
  end

  def sign_in
    if @user.authenticate
      session[:token] = @user.response.dig('data', 'token', 'access_token')
      session[:refresh_token] = @user.response.dig('data', 'token', 'refresh_token')
      session[:user_email] = @user.email

      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @user.response, status: :ok }
      end
    else
      reset_session

      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
    end
  end

  def sign_out
    reset_session

    if @user.token_revoke
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: @user.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @user.errors['message']
          redirect_to root_path
        end
        format.json { render json: @user.errors, status: :conflict }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = begin
      User.new(user_params)
    rescue StandardError
      User.new
    end
  end

  def set_tokens
    @user.token = session[:token] if @user.token.nil?
    @user.refresh_token = session[:refresh_token] if @user.refresh_token.nil?
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
                                 :refresh_token)
  end
end
