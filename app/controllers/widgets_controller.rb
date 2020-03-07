# frozen_string_literal: true

class WidgetsController < ApplicationController
  before_action :set_widget
  before_action :set_user_token

  # GET /widgets
  def index
    if @widget.get_public_widgets
      render json: @widget.response, status: :ok
    else
      render json: @widget.errors, status: :conflict
    end
  end

  def visible
    search_term = params.dig('widget', 'search_term')
    if @widget.get_visible_widgets(search_term)
      render json: @widget.response, status: :ok
    else
      render json: @widget.errors, status: :conflict
    end
  end

  def create
    @widget.new_record = true

    if @widget.save
      render json: @widget.response, status: :ok
    else
      render json: @widget.errors, status: :conflict
    end
  end

  def update
    @widget.id = params[:id]
    @widget.new_record = false

    if @widget.save
      render json: @widget.response, status: :ok
    else
      render json: @widget.errors, status: :conflict
    end
  end

  def destroy
    @widget.id = params[:id]
    if @widget.delete_widget
      render json: @widget.response, status: :ok
    else
      render json: @widget.errors, status: :conflict
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_widget
    @widget = begin
                Widget.new(widget_params)
              rescue StandardError
                Widget.new
              end
  end

  def set_user_token
    @widget.user_token = session[:token] if @widget.user_token.nil?
  end

  # Only allow a list of trusted parameters through.
  def widget_params
    params.require(:widget).permit(:id, :name, :description, :kind, :search_term, :user_token) || {}
  end
end
