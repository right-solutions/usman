module Usman
  module Api
    module V1
      class DocsController < DocsBaseController

        def register
          set_title("Register API")
          @request_type = "POST"
          @end_point = "/api/v1/register"
          @description = "This API will register the user and the devise and will send an OTP for verification"

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
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/register")

          render 'kuppayam/api/docs/show'
        end

        def resend_otp
          set_title("Resend OTP API")
          @request_type = "POST"
          @end_point = "/api/v1/resend_otp"
          @description = "This API will resend the OTP for verification"

          @warning = "A maximum of 5 attempt is allowed for resending the OTP. 6th request will block the device."
          
          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1"]

          set_nav("docs/resend_otp")

          render 'kuppayam/api/docs/show'
        end

        def verify_otp
          set_title("Verify OTP API")
          @request_type = "POST"
          @end_point = "/api/v1/verify_otp"
          @description = "This API verify the OTP and returns the API token for further communication"
          
          @input_params = {
            otp: { mandatory: true, description: "One Time Password you have received via SMS. (Five Digit)", example: "", default: "" },
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/verify_otp")

          render 'kuppayam/api/docs/show'
        end

        def accept_tac
          set_title("Accept T&C API")
          @request_type = "POST"
          @end_point = "/api/v1/accept_tac"
          @description = "This API record the acceptance of the terms and condition."
          
          @info = "The user will have to accept terms and conditions everytime he registers a new device"
          
          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"# 
          # @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/accept_tac")

          render 'kuppayam/api/docs/show'
        end

        def create_profile
          set_title("Create Profile API")
          @request_type = "POST"
          @end_point = "/api/v1/accept_tac"
          @description = "This API will return so and so and create blah blah blah"
          
          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"# 
          # @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/create_profile")

          render 'kuppayam/api/docs/show'
        end

        def update_profile
          set_title("Update Profile API")
          @request_type = "POST"
          @end_point = "/api/v1/accept_tac"
          @description = "This API will return so and so and create blah blah blah"
          
          @input_params = {
            uuid: { mandatory: true, description: "Universal Unique Identifier. iOS or Android will give you this programatically.", example: "", default: "" },
            dialing_prefix: { mandatory: true, description: "International Dialing Prefix for countries", example: "+971", default: "" },
            mobile_number: { mandatory: true, description: "Mobile Number without Dialing Prefix", example: "If your mobile number is +971 54 312 9876, pass '543129876' without spaces.", default: "" }
          }

          @example_path = "usman/api/v1/docs/"# 
          # @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/update_profile")

          render 'kuppayam/api/docs/show'
        end

      end
    end
  end
end
