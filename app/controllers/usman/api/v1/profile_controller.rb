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
                if @user.valid?
                  @current_registration.user = @user
                  @success = true
                  @alert = {
                    heading: I18n.translate("api.profile.profile_created.heading"),
                    message: I18n.translate("api.profile.profile_created.message")
                  }
                  @data = {
                            registration: @reg_data.registration,
                            device: @reg_data.device
                          }
                else
                  @errors = @user.errors
                  @success = false
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
          params.require(:profile).permit(:name, :gender, :date_of_birth, :email, :country_id, :city_id)
        end

      end
    end
  end
end

