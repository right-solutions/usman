module Usman
  module Api
    module V1
      class ProfileController < Usman::Api::V1::BaseController

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
                  @current_registration.user = @user
                  
                  @current_registration.country = @country if @country
                  @current_registration.city = @city if @city

                  @current_registration.save

                  @current_user = @user
                  @success = true
                  @alert = {
                    heading: I18n.translate("api.profile.profile_created.heading"),
                    message: I18n.translate("api.profile.profile_created.message")
                  }
                  @data = {"user": ActiveModelSerializers::SerializableResource.new(@user, serializer: ProfileSerializer)}
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
                @user.date_of_birth = permitted_params[:date_of_birth]
                @user.email = permitted_params[:email]

                @country = Country.find_by_id(permitted_params[:country_id])
                @city = City.find_by_id(permitted_params[:city_id])

                if @user.valid?
                  @user.save
                  
                  @current_registration.country = @country if @country
                  @current_registration.city = @city if @city

                  @current_registration.save

                  @success = true
                  @alert = {
                    heading: I18n.translate("api.profile.profile_created.heading"),
                    message: I18n.translate("api.profile.profile_created.message")
                  }
                  @data = {"user": ActiveModelSerializers::SerializableResource.new(@user, serializer: ProfileSerializer)}
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

        private

        def permitted_params
          params.permit(:name, :gender, :date_of_birth, :email, :country_id, :city_id)
        end

      end
    end
  end
end

