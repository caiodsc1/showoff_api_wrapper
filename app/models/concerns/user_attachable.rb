require 'user/image.rb'

module UserAttachable
  extend ActiveSupport::Concern

  included do
    delegate :original_url, to: :images
  end

  def images
    @images
  end

  def images=(params)
    @images = User::Image.new(params.as_json)
  end
end
