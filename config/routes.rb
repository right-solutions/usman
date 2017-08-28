Usman::Engine.routes.draw do

	# Sign In URLs for users
  get  '/sign_in',                    to: "sessions#sign_in",               as: :sign_in
  post '/create_session',             to: "sessions#create_session",        as: :create_session
  get  '/forgot_password_form',       to: "sessions#forgot_password_form",  as: :forgot_password_form
  post '/forgot_password',            to: "sessions#forgot_password",       as: :forgot_password
  get  '/reset_password_form/:id',    to: "sessions#reset_password_form",   as: :reset_password_form
  put  '/reset_password_update/:id',  to: "sessions#reset_password_update", as: :reset_password_update
  
  # Logout Url
  delete  '/sign_out' ,               to: "sessions#sign_out",  as:  :sign_out

  get   '/my_account',        to: "my_account#index",  as:   :my_account
  get   '/dashboard/usman',   to: "dashboard#index",  as:   :dashboard
  
  resources :users do
    member do
      put :masquerade, as: :masquerade
      put :update_status, as:  :update_status
      put :make_super_admin, as:  :make_super_admin
      put :remove_super_admin, as:  :remove_super_admin
    end
  end

  resources :roles do
    resources :users, :controller => "user_roles"
  end

  resources :features do
    member do
      put :update_status, as:  :update_status
    end
  end

  resources :permissions

  namespace :api do
    namespace :v1 do
      post :register, :controller => "/api/v1/registrations"
      post :resend_otp, :controller => "/api/v1/registrations"
      post :verify, :controller => "/api/v1/registrations"
    end
  end

  get '/api/v1/docs/usman',         to: "docs#index",  as:   :docs_index
  
  #get "/api/v1/docs/register", :controller => "/usman/api_docs"
  #get "/api/v1/docs/resend_otp", :controller => "/usman/api_docs"
  #get "/api/v1/docs/verify", :controller => "/usman/api_docs"

end
