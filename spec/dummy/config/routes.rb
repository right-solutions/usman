Rails.application.routes.draw do

	mount Usman::Engine => "/"
	mount Pattana::Engine => "/"
	
	get   '/landing', to: "landing#index",  as: :user_landing
  root 'usman/sessions#sign_in'
  
end
