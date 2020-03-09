class WidgetService
  @@create_attributes = %w[name description kind].freeze
  @@update_attributes = %w[name description kind].freeze

  def self.create_widget(widget)
    ApiService.call(method: :post, url: '/widgets',
                    params: { widget: widget.as_json(only: @@create_attributes) },
                    headers: { authorization: "Bearer #{widget.token}" })
  end

  def self.update_widget(widget)
    ApiService.call(method: :put, url: "/widgets/#{widget.id}",
                    params: { widget: widget.as_json(only: @@update_attributes) },
                    headers: { authorization: "Bearer #{widget.token}" })
  end

  def self.delete_widget(widget)
    ApiService.call(method: :delete, url: "/widgets/#{widget.id}",
                    headers: { authorization: "Bearer #{widget.token}" })
  end

  def self.public_widgets(widget)
    ApiService.call(method: :get, url: '/widgets',
                    headers: { authorization: "Bearer #{widget.token}" })
  end

  def self.visible_widgets(search_term = nil)
    ApiService.call(method: :get, url: '/widgets/visible',
                    params: { term: search_term }.compact)
  end
end
