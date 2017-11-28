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
  
  scope :admin do

    resources :registrations, only: [:index, :show] do
      resources :devices, :controller => "registration_devices", only: [:index, :show]
      member do
        put :update_status, as:  :update_status
      end
    end

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

  end
  
  namespace :api do
    namespace :v1 do
      
      # Registrations
      post :register, :controller => "registrations", as: :register
      post :resend_otp, :controller => "registrations", as: :resend_otp
      post :verify_otp, :controller => "registrations", as: :verify_otp
      post :accept_tac, :controller => "registrations", as: :accept_tac

      # Profile
      post :create_profile, :controller => "profile", as: :create_profile
      put :update_profile, :controller => "profile", as: :update_profile
      get :profile_info, :controller => "profile", as: :profile_info

      # Contacts
      post 'contacts/sync', :controller => "contacts", action: :sync, as: :sync_contacts
      get 'contacts', :controller => "contacts", action: :index, as: :contacts
      get 'contacts/:id', :controller => "contacts", action: :show, as: :contact

      # Profile Picture
      post 'profile/profile_picture_base64', :controller => "profile_picture", action: :profile_picture_base64, as: :profile_picture_base64
      post 'profile/profile_picture', :controller => "profile_picture", action: :profile_picture, as: :profile_picture
      delete 'profile/profile_picture', :controller => "profile_picture", action: :destroy_profile_picture, as: :destroy_profile_picture
    end
  end
  
  scope :docs, as: 'docs' do
    namespace :api do
      namespace :v1 do
        get 'register', :controller => "docs"
        get 'resend_otp', :controller => "docs"
        get 'verify_otp', :controller => "docs"
        get 'accept_tac', :controller => "docs"
        get 'create_profile', :controller => "docs"
        get 'update_profile', :controller => "docs"
        get 'update_profile', :controller => "docs"
        get 'get_profile_info', :controller => "docs"

        get 'contacts_sync', :controller => "docs"
        get 'all_contacts', :controller => "docs"
        get 'single_contacts', :controller => "docs"

        get 'upload_profile_picture_base64', :controller => "docs"
        get 'upload_profile_picture', :controller => "docs"
        get 'delete_profile_picture', :controller => "docs"
      end
    end
  end

end
