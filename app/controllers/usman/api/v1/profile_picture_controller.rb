module Usman
	module Api
		module V1
			class ProfilePictureController < BaseController

				include ImageUploaderHelper

				def base64_profile_picture
					proc_code = Proc.new do
						@user = User.find_by_id(params[:id])
						unless @user
							@success = false
							@errors = {
								heading: I18n.translate("api.profile_picture.not_found.heading"),
								message: I18n.translate("api.profile_picture.not_found.message")
							}
						else
							user_image = Image::ProfilePicture.new
				      user_image.imageable = @user

				      begin
				      	if params[:image] && !params[:image].blank?
					      	user_image.image = image_params[:image_path]
					      	user_image.valid?
						      if user_image.errors.any?
						      	@success = false
										@errors = {
											heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
											message: I18n.translate("api.profile_picture.image_save_failed.message"),
											details: user_image.errors.full_messages
										}
						      else
						      	@success = true
						      	@alert = {
			                heading: I18n.translate("api.profile_picture.image_saved.heading"),
			                message: I18n.translate("api.profile_picture.image_saved.message")
			              }
										@data = ActiveModelSerializers::SerializableResource.new(user_image, serializer: ProfilePictureSerializer)
						      	user_image.save
						      end
						    else
						    	@success = false
										@errors = {
											heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
											message: I18n.translate("api.profile_picture.image_save_failed.message"),
											details: "Image can't be blank"
										}
						    end
				    	rescue Exception => e
				    		@success = false
								@errors = {
									heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
									message: I18n.translate("api.profile_picture.image_save_failed.message"),
									details: "Unable to parse the base64 image data"
								}
				    	end
				      
				      
						end
					end
					render_json_response(proc_code)
				end

				def profile_picture
					proc_code = Proc.new do
						@user = User.find_by_id(params[:id])
						unless @user
							@success = false
							@errors = {
								heading: I18n.translate("api.profile_picture.not_found.heading"),
								message: I18n.translate("api.profile_picture.not_found.message")
							}
						else
							user_image = Image::ProfilePicture.new
				      user_image.imageable = @user

				      begin
				      	if params[:image] && !params[:image].blank?
					      	user_image.image = params[:image]
					      	user_image.valid?
						      if user_image.errors.any?
						      	@success = false
										@errors = {
											heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
											message: I18n.translate("api.profile_picture.image_save_failed.message"),
											details: user_image.errors.full_messages
										}
						      else
						      	@success = true
						      	@alert = {
			                heading: I18n.translate("api.profile_picture.image_saved.heading"),
			                message: I18n.translate("api.profile_picture.image_saved.message")
			              }
										@data = ActiveModelSerializers::SerializableResource.new(user_image, serializer: ProfilePictureSerializer)
						      	user_image.save
						      end
						    else
						    	@success = false
										@errors = {
											heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
											message: I18n.translate("api.profile_picture.image_save_failed.message"),
											details: "Image can't be blank"
										}
						    end
				    	rescue Exception => e
				    		@success = false
								@errors = {
									heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
									message: I18n.translate("api.profile_picture.image_save_failed.message"),
									details: "Unable to parse the base64 image data"
								}
				    	end
				      
				      
						end
					end
					render_json_response(proc_code)
				end

				private
				
			end
		end
	end
end

