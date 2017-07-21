module Usman
	module Api 
		module V1
			class UsersController < ActionController::API

				def create
					@user = User.new(user_params)
					if @user.valid?
						@user.save
						render :json => {:success=>true,:user => @user.as_json(
							:only => [:id, :name, :username, :email, :phone])}, :status => 201
					else
						render :json => {:success=>false,:error => @user.errors.full_messages.join(', ')}, :status => 404
					end
				end

				def user_params
					params.require(:user).permit(:name,:username,:email,:phone, :password, :password_confirmation)
				end
			end
		end
	end
end
