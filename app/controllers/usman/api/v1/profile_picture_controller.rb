module Usman
	module Api
		module V1
			class ProfilePictureController < BaseController

				include ImageUploaderHelper

				def profile_picture_base64
					proc_code = Proc.new do
						if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                user_image = @current_user.profile_picture || Image::ProfilePicture.new(imageable: @current_user)
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
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.profile.registration_details_missing.heading"),
                message: I18n.translate("api.profile.registration_details_missing.message")
              }
            end
					end
					render_json_response(proc_code)
				end

				def profile_picture
					proc_code = Proc.new do
						if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                user_image = @current_user.profile_picture || Image::ProfilePicture.new(imageable: @current_user)
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
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.profile.registration_details_missing.heading"),
                message: I18n.translate("api.profile.registration_details_missing.message")
              }
            end
					end
					render_json_response(proc_code)
				end

				def destroy_profile_picture
					proc_code = Proc.new do
						if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                user_image = @current_user.profile_picture
                unless user_image
	                @success = false
	                @errors = {
	                  heading: I18n.translate("api.profile_picture.profile_picture_does_not_exists.heading"),
                  	message: I18n.translate("api.profile_picture.profile_picture_does_not_exists.message")
	                }
	              else
						      begin
						      	@success = true
						      	@alert = {
			                heading: I18n.translate("api.profile_picture.image_deleted.heading"),
			                message: I18n.translate("api.profile_picture.image_deleted.message")
			              }
										user_image.destroy
						    	rescue Exception => e
						    		@success = false
										@errors = {
											heading: I18n.translate("api.profile_picture.image_delete_failed.heading"),
											message: I18n.translate("api.profile_picture.image_delete_failed.message"),
											details: "Unable to parse the base64 image data"
										}
						    	end
						    end
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.profile.registration_details_missing.heading"),
                message: I18n.translate("api.profile.registration_details_missing.message")
              }
            end
					end
					render_json_response(proc_code)
				end

				private
				
			end
		end
	end
end

