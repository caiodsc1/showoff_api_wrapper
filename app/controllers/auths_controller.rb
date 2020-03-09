# frozen_string_literal: true

class AuthsController < ApplicationController
  before_action :set_auth

  def create
    if @auth.create
      session[:token] = @auth.response.dig('data', 'token', 'access_token')
      session[:refresh_token] = @auth.response.dig('data', 'token', 'refresh_token')

      render json: @auth.response, status: :ok
    else
      render json: @auth.errors, status: :conflict
    end
  end

  def revoke
    @auth.token = session[:token] if @auth.token.nil?

    if @auth.revoke
      reset_session

      render json: @auth.response, status: :ok
    else
      render json: @auth.errors, status: :conflict
    end
  end

  def refresh
    @auth.refresh_token = session[:refresh_token] if @auth.refresh_token.nil?

    if @auth.refresh
      render json: @auth.response, status: :ok
    else
      render json: @auth.errors, status: :conflict
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_auth
    @auth = begin
              AuthService.new(auth_params)
            rescue StandardError
              AuthService.new
            end
  end

  # Only allow a list of trusted parameters through.
  def auth_params
    params.require(:auth).permit(:username, :password, :token, :refresh_token)
  end
end
