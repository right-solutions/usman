module Usman
  module Api
    module V1
      class DocsController < DocsBaseController

        def register
          set_title("Register API")
          @request_type = "POST"
          @end_point = "/api/v1/register"
          @description = "This API will register the user and the device and will send an OTP for verification. API will return the api_token if the device is already registered."

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            country_id: { mandatory: true, description: "Country ID is an integer. You may get it from Countries API", example: "100", default: "" },
            city_id: { mandatory: false, description: "City ID is an integer. You may get it from Cities API", example: "1030", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" },
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            device_token: { mandatory: true, description: "Device Token is a unique token for your device", example: "", default: "" },
            device_name: { mandatory: false, description: "The name of your Device", example: "Apple iPhone", default: "" },
            device_type: { mandatory: false, description: "", example: "The kind of device you have", default: "iPhone 7 plus" },
            operating_system: { mandatory: false, description: "Operating System Name", example: "", default: "" },
            software_version: { mandatory: false, description: "Software / OS Version", example: "", default: "" }
          }

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/register")

          render 'kuppayam/api/docs/show'
        end

        def resend_otp
          set_title("Resend OTP API")
          @request_type = "POST"
          @end_point = "/api/v1/resend_otp"
          @description = "This API will resend the OTP for verification"

          @warning = "A maximum of 3 attempt is allowed for resending the OTP. 6th request will block the device."
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3", "neg_case_4"]

          set_nav("docs/resend_otp")

          render 'kuppayam/api/docs/show'
        end

        def verify_otp
          set_title("Verify OTP API")
          @request_type = "POST"
          @end_point = "/api/v1/verify_otp"
          @description = "This API verify the OTP and returns the API token for further communication"
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            otp: { mandatory: true, description: "One Time Password you have received via SMS. (Five Digit)", example: "", default: "" },
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "pos_case_2", "neg_case_1", "neg_case_2", "neg_case_3", "neg_case_4"]

          set_nav("docs/verify_otp")

          render 'kuppayam/api/docs/show'
        end

        def accept_tac
          set_title("Accept T&C API")
          @request_type = "POST"
          @end_point = "/api/v1/accept_tac"
          @description = "This API record the acceptance of the terms and condition."
          
          @info = "The user will have to accept terms and conditions everytime he registers a new device"
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " }
          }

          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"# 
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/accept_tac")

          render 'kuppayam/api/docs/show'
        end

        def create_profile
          set_title("Create Profile API")
          @request_type = "POST"
          @end_point = "/api/v1/create_profile"
          @description = "This API will create a profile for a newly registered user"
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. This is must for creating a profile. You need to register with your mobile number and verify the otp before you could create a profile" }
          }

          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"# 
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/create_profile")

          render 'kuppayam/api/docs/show'
        end

        def update_profile
          set_title("Update Profile API")
          @request_type = "POST"
          @end_point = "/api/v1/update_profile"
          @description = "This API will update the profile details"
          
          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. This is must for creating a profile. You need to register with your mobile number and verify the otp before you could create a profile" }
          }

          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"# 
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/update_profile")

          render 'kuppayam/api/docs/show'
        end

        def profile
          set_title("Profile API")
          @request_type = "GET"
          @end_point = "/api/v1/profile/base64_profile_picture"
          @description = "This API will return the details of the profile requested including image urls."

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2"]

          set_nav("docs/profile")

          render 'kuppayam/api/docs/show'
        end

        def base64_profile_picture
          set_title("Upload Profile Picture API (base64)")
          @request_type = "POST"
          @end_point = "/api/v1/profile/base64_profile_picture"
          @description = "This API will return the details of the profile requested including image urls."

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2"]

          set_nav("docs/base64_profile_picture")

          render 'kuppayam/api/docs/show'
        end

        def profile_picture
          set_title("Upload Profile Picture API")
          @request_type = "POST"
          @end_point = "/api/v1/profile/profile_picture"
          @description = "This API will return the details of the profile requested including image urls."

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/profile_picture")

          render 'kuppayam/api/docs/show'
        end

        def destroy_profile_picture
          set_title("Delete Profile Picture API")
          @request_type = "DELETE"
          @end_point = "/api/v1/profile"
          @description = "This API will return the details of the profile requested including image urls."

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/destroy_profile_picture")

          render 'kuppayam/api/docs/show'
        end

      end
    end
  end
end
