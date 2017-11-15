module Usman
  module Api
    module V1
      class ProfileController < Usman::Api::V1::BaseController

        include ImageUploaderHelper

        def create_profile
          proc_code = Proc.new do
            if @current_registration
              if @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_already_exists.heading"),
                  message: I18n.translate("api.profile.user_already_exists.message")
                }
              else
                @user = User.new
                @user.name = permitted_params[:name]
                @user.generate_username_and_password
                @user.gender = permitted_params[:gender]
                @user.date_of_birth = permitted_params[:date_of_birth]
                @user.email = permitted_params[:email]
                
                @country = Country.find_by_id(permitted_params[:country_id])
                @city = City.find_by_id(permitted_params[:city_id])

                if @user.valid?
                  @user.save
                  @user.approve!
                  @current_registration.user = @user
                  
                  @user.country = @country if @country
                  @user.city = @city if @city

                  @current_registration.save

                  # Saving the profile image if passed
                  begin
                    if params[:image] && !params[:image].blank?
                      user_image = @user.profile_picture || Image::ProfilePicture.new(imageable: @user)
                      user_image.image = params[:image]
                      user_image.valid?
                      if user_image.errors.any?
                        @errors = {
                          heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
                          message: I18n.translate("api.profile_picture.image_save_failed.message"),
                          details: user_image.errors.full_messages
                        }
                      else
                        user_image.save
                        @user.reload
                      end
                    end
                  rescue
                    @errors = {
                      heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
                      message: I18n.translate("api.profile_picture.image_save_failed.message"),
                      details: user_image.errors.full_messages
                    }
                  end

                  @current_user = @user
                  @success = true
                  @alert = {
                    heading: I18n.translate("api.profile.profile_created.heading"),
                    message: I18n.translate("api.profile.profile_created.message")
                  }
                  @data = ActiveModelSerializers::SerializableResource.new(@user, serializer: ProfileSerializer)
                else
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.profile.invalid_inputs.heading"),
                    message: I18n.translate("api.profile.invalid_inputs.message"),
                    details: @user.errors
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

        def update_profile
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                @user = @current_user
                @user.name = permitted_params[:name]
                @user.gender = permitted_params[:gender]
                @user.dummy = false
                @user.date_of_birth = permitted_params[:date_of_birth]
                @user.email = permitted_params[:email]

                @country = Country.find_by_id(permitted_params[:country_id])
                @city = City.find_by_id(permitted_params[:city_id])

                if @user.valid?
                  @user.dummy = false
                  @user.save
                  
                  @user.country = @country if @country
                  @user.city = @city if @city

                  @current_registration.save

                  # Saving the profile image if passed
                  begin
                    if params[:image] && !params[:image].blank?
                      user_image = @user.profile_picture || Image::ProfilePicture.new(imageable: @user)
                      user_image.image = params[:image]
                      user_image.valid?
                      if user_image.errors.any?
                        @errors = {
                          heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
                          message: I18n.translate("api.profile_picture.image_save_failed.message"),
                          details: user_image.errors.full_messages
                        }
                      else
                        user_image.save
                        @user.reload
                      end
                    end
                  rescue
                    @errors = {
                      heading: I18n.translate("api.profile_picture.image_save_failed.heading"),
                      message: I18n.translate("api.profile_picture.image_save_failed.message"),
                      details: user_image.errors.full_messages
                    }
                  end

                  @success = true
                  @alert = {
                    heading: I18n.translate("api.profile.profile_created.heading"),
                    message: I18n.translate("api.profile.profile_created.message")
                  }
                  @data = ActiveModelSerializers::SerializableResource.new(@user, serializer: ProfileSerializer)
                else
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.profile.invalid_inputs.heading"),
                    message: I18n.translate("api.profile.invalid_inputs.message"),
                    details: @user.errors
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

        def profile_info
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                @current_user
                @success = true
                @data = ActiveModelSerializers::SerializableResource.new(@current_user, serializer: ProfileSerializer)
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

        def permitted_params
          params.permit(:name, :gender, :date_of_birth, :email, :country_id, :city_id)
        end

      end
    end
  end
end

