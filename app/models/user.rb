# frozen_string_literal: true

class User

  attr_accessor :id,
                :email,
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

  def initialize(*args)
    args.first&.each do |attr, value|
      try("#{attr}=", value)
    end
  end

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

  def show_logged_in_user
    success, self.response = UserService.show_logged_in_user(self)
    success
  end

  def show_user_id
    success, self.response = UserService.show_user_id(self)
    success
  end
end
