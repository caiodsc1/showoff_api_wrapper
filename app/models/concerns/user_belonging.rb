# frozen_string_literal: true

module UserBelonging
  extend ActiveSupport::Concern

  def user
    @user
  end

  def user=(user_params)
    @user = User.new(user_params.as_json)
  end
end
