Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources 'users', only: ['create', 'update'] do
    collection do
      get '/me', action: 'show_authenticated_user'
      get '/check_email', action: 'check_email'
      get '/reset_password', action: 'reset_password'
      post '/change_password', action: 'change_password'
      get '/me/widgets', action: 'private_widgets', as: 'my_widgets'
      post '/sign_in', action: 'sign_in'
      get '/sign_out', action: 'sign_out'
      get '/:id', action: 'show_user_by_id', as: 'by_id'
      get '/:id/widgets', action: 'widgets_by_user_id'
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

  root 'widgets#visible'
end
