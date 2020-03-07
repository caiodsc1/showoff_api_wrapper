Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources 'users', only: ['create', 'update'] do
    collection do
      get '/me', action: 'show_logged_in_user'
      get '/check_email', action: 'check_email'
      post '/reset_password', action: 'reset_password'
      post '/change_password', action: 'change_password'
      get '/me/widgets', action: 'get_private_widgets'
      get '/:id', action: 'show_user_id'
      get '/:id/widgets', action: 'get_widgets_by_user_id'
    end
  end

  resources 'widgets', only: ['index', 'create', 'update', 'destroy'] do
    get '/visible', action: 'visible', on: :collection
  end

  namespace 'auths' do
    post '/create', action: 'create'
    post '/refresh', action: 'refresh'
    post '/revoke', action: 'revoke'
  end
end
