Rails.application.routes.draw do

	#mount Kuppayam::Engine => "/abcd"

	mount Usman::Engine => "/"

	get   '/landing', to: "landing#index",  as: :user_landing

end
