# frozen_string_literal: true

class WidgetsController < ApplicationController
  before_action :set_widget, :set_user_token

  def index
    if @widget.public_widgets
      render json: @widget.response, status: :ok
    else
      render json: @widget.errors, status: :conflict
    end
  end

  def visible
    search_term = params[:search_term]

    if @widget.visible_widgets(search_term)
      respond_to do |format|
        format.html { @widgets = helpers.prepare_for_collection(@widget) }
        format.json { render json: @widget.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @widget.errors['message']
          redirect_to root_path
        end
        format.json { render json: @widget.errors, status: :conflict }
      end
    end
  end

  def create
    @widget.new_record = true

    if @widget.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.json { render json: @widget.response, status: :ok }
      end
    else
      respond_to do |format|
        format.html do
          flash[:error] = @widget.errors['message']
          redirect_back fallback_location: root_path
        end
        format.json { render json: @widget.errors, status: :conflict }
      end
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
    params.require(:widget).permit(:id, :name, :description, :kind, :user_token) || {}
  end
end
