# frozen_string_literal: true

class User < ApplicationModel

  attr_accessor :id,
                :email,
                :name,
                :first_name,
                :last_name,
                :password,
                :current_password,
                :new_password,
                :date_of_birth,
                :image_url,
                :new_record,
                :token,
                :response

  alias errors response

  include UserWidgetOwner
  include UserAuthenticable
  include UserAttachable

  def save
    success, self.response = if new_record
                               UserService.create_user(self)
                             else
                               UserService.update_user(self)
                             end
    self.id = response.dig('data', 'user', 'id') if success && new_record
    success
  end

  def check_email
    success, self.response = UserService.check_email(self)
    success
  end

  def reset_password
    success, self.response = UserService.reset_password(self)
    success
  end

  def change_password
    success, self.response = UserService.change_password(self)
    success
  end

  def show_authenticated_user
    success, self.response = UserService.show_authenticated_user(self)
    success
  end

  def show_user_by_id
    success, self.response = UserService.show_user_by_id(self)
    success
  end

  def reload
    response.dig('data', 'user')&.each do |attr, value|
      try("#{attr}=", value)
    end
  end
end
