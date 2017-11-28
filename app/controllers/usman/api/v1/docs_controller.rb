module Usman
  module Api
    module V1
      class DocsController < Usman::AdminController

        layout 'kuppayam/docs'

        before_action :set_nav_items, :set_tab_items
        helper_method :breadcrumb_home_path

        def register
          set_title("Register API")
          @request_type = "POST"
          @end_point = "/api/v1/register"
          @description = <<-eos
          This API will register the user and the device and will send an OTP for verification. <br>
          This API can also be used for user login.  <br>
          If the user is already registered, verifying the OTP will get the user logged in (return API token)
          eos

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

          set_nav("docs/usman/register")

          render 'kuppayam/api/docs/show'
        end

        def resend_otp
          set_title("Resend OTP API")
          @request_type = "POST"
          @end_point = "/api/v1/resend_otp"
          @description = <<-eos
          This API will resend the OTP for verification
          eos

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

          set_nav("docs/usman/resend_otp")

          render 'kuppayam/api/docs/show'
        end

        def verify_otp
          set_title("Verify OTP API")
          @request_type = "POST"
          @end_point = "/api/v1/verify_otp"
          @description = <<-eos
          This API verify the OTP.  <br>
          It will return the API token for further communication if the user & device has already been registered. <br>
          If not, API token is returned in the positive response of Accpet T&C API
          eos
          
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

          set_nav("docs/usman/verify_otp")

          render 'kuppayam/api/docs/show'
        end

        def accept_tac
          set_title("Accept T&C API")
          @request_type = "POST"
          @end_point = "/api/v1/accept_tac"
          @description = <<-eos
          This API record the acceptance of the terms and condition and will finish the registration of user & device. <br>
          It will return API token which can be used for further communication.
          eos
          
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

          set_nav("docs/usman/accept_tac")

          render 'kuppayam/api/docs/show'
        end

        def create_profile
          set_title("Create Profile API")
          @request_type = "POST"
          @end_point = "/api/v1/create_profile"
          @description = <<-eos
          This API will create a profile for a newly registered user
          eos
          
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
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/usman/create_profile")

          render 'kuppayam/api/docs/show'
        end

        def update_profile
          set_title("Update Profile API")
          @request_type = "POST"
          @end_point = "/api/v1/update_profile"
          @description = <<-eos
          This API will update the profile details. <br>
          Note the the user id is not passed but the API token in header.
          eos
          
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
          @examples = ["pos_case_1", "pos_case_2", "pos_case_3", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/usman/update_profile")

          render 'kuppayam/api/docs/show'
        end

        def get_profile_info
          set_title("Get Profile Info API")
          @request_type = "GET"
          @end_point = "/api/v1/profile_info"
          @description = <<-eos
          This API will return the details of the profile requested including profile picture urls
          eos

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2"]

          set_nav("docs/usman/get_profile_info")

          render 'kuppayam/api/docs/show'
        end


        def contacts_sync
          set_title("Sync Contacts")
          @request_type = "POST"
          @end_point = "/api/v1/contacts/sync"
          @description = <<-eos
          This API sync all the contacts with donedeal backend 
          eos

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"103652edd6bbdc72b770d3c8cb88b18d\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {
                            contacts: { 
                              mandatory: true, 
                              description: "Json array of contact informations", 
                              example: '[                          
                                          {
                                            "name": "Mohanlala",
                                            "account_type": "com.mollywood",
                                            "email": "mohanlal@gmail.com",
                                            "address": "xyz, str, efg",
                                            "contact_number_1": "87393993884",
                                            "contact_number_2":"9846557465"
                                          },
                                          {
                                            "name": "Mammukka",
                                            "account_type": "com.mollywood1",
                                            "email": "mammukka@gmail.com",
                                            "address": "xyz, str, efg",
                                            "contact_number_1": "7046338475",
                                            "contact_number_2":"8086500502"
                                          }
                                        ]', 
                              default: "" 
                            },
                        }  

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1"]

          set_nav("docs/usman/contacts_sync")

          render 'kuppayam/api/docs/show'
        end

        def all_contacts
          set_title("Get All Contacts")
          @request_type = "GET"
          @end_point = "/api/v1/contacts"
          @description = <<-eos
          This API fetch all the contacts of coresponding logged user
          eos

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"103652edd6bbdc72b770d3c8cb88b18d\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}  

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1"]

          set_nav("docs/usman/all_contacts")

          render 'kuppayam/api/docs/show'
        end    

        def single_contacts
          set_title("Single Contacts")
          @request_type = "GET"
          @end_point = "/api/v1/contacts/:id"
          @description = <<-eos
          This API fetch single contacts from the Data base coresponding logged user
          eos

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"103652edd6bbdc72b770d3c8cb88b18d\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}  

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1"]

          set_nav("docs/usman/single_contacts")

          render 'kuppayam/api/docs/show'
        end

        def upload_profile_picture_base64
          set_title("Upload Profile Picture API (base64)")
          @request_type = "POST"
          @end_point = "/api/v1/profile/profile_picture_base64"
          @description = <<-eos
          This APi will upload an image to a profile and will set it as the profile picture. <br>
          It accept an image embeded in a json with base64 encoding.
          eos

          @warning = "The image has to be base64 encoded."

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2"]

          set_nav("docs/usman/upload_profile_picture_base64")

          render 'kuppayam/api/docs/show'
        end

        def upload_profile_picture
          set_title("Upload Profile Picture API")
          @request_type = "POST"
          @end_point = "/api/v1/profile/upload_profile_picture"
          @description = <<-eos
          This APi will upload an image to a profile and will set it as the profile picture. <br>
          It accept an image in binary format
          eos

          @input_headers = {
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @warning = "Do not set Content Type Json as this is a multipart file upload request"

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2", "neg_case_3"]

          set_nav("docs/usman/upload_profile_picture")

          render 'kuppayam/api/docs/show'
        end

        def delete_profile_picture
          set_title("Delete Profile Picture API")
          @request_type = "DELETE"
          @end_point = "/api/v1/profile/profile_picture"
          @description = <<-eos
          This API will delete the profile picture
          eos

          @input_headers = {
            "Content-Type" => { value: "application/json", description: "The MIME media type for JSON text is application/json. This is to make sure that a valid json is returned. The default encoding is UTF-8. " },
            "Authorization" => { value: "Token token=\"87b01adbba90824b57add8cc06ad8738\"", description: "Put the API Token here. You shall get the API token after registering your device" }
          }

          @input_params = {}

          @example_path = "usman/api/v1/docs/"
          @examples = ["pos_case_1", "neg_case_1", "neg_case_2"]

          set_nav("docs/usman/delete_profile_picture")

          render 'kuppayam/api/docs/show'
        end

        private

        def set_nav_items
          @nav_items = {
            register: { nav_class: "docs/usman/register", icon_class: "fa-group", url: usman.docs_api_v1_register_path, text: "Registraions API"},
            resend_otp: { nav_class: "docs/usman/resend_otp", icon_class: "fa-send", url: usman.docs_api_v1_resend_otp_path, text: "Resend OTP API"},
            verify_otp: { nav_class: "docs/usman/verify_otp", icon_class: "fa-thumbs-up", url: usman.docs_api_v1_verify_otp_path, text: "Verify OTP API"},
            accept_tac: { nav_class: "docs/usman/accept_tac", icon_class: "fa-check-square-o", url: usman.docs_api_v1_accept_tac_path, text: "Accept T&C API"},
            create_profile: { nav_class: "docs/usman/create_profile", icon_class: "fa-user", url: usman.docs_api_v1_create_profile_path, text: "Create Profile API"},
            update_profile: { nav_class: "docs/usman/update_profile", icon_class: "fa-user", url: usman.docs_api_v1_update_profile_path, text: "Update Profile API"},
            get_profile_info: { nav_class: "docs/usman/get_profile_info", icon_class: "fa-user", url: usman.docs_api_v1_get_profile_info_path, text: "Get Profile Info API"},
            contacts_sync: { nav_class: "docs/usman/contacts_sync", icon_class: "fa-user", url: usman.docs_api_v1_contacts_sync_path, text: "Contact Syncing"},
            all_contacts: { nav_class: "docs/usman/all_contacts", icon_class: "fa-user", url: usman.docs_api_v1_all_contacts_path, text: "Get All Contacts"},
            single_contacts: { nav_class: "docs/usman/single_contacts", icon_class: "fa-user", url: usman.docs_api_v1_single_contacts_path, text: "Single Contact"},
            upload_profile_picture_base64: { nav_class: "docs/usman/upload_profile_picture_base64", icon_class: "fa-photo", url: usman.docs_api_v1_upload_profile_picture_base64_path, text: "Upload Profile Picture (Base64)"},
            upload_profile_picture: { nav_class: "docs/usman/upload_profile_picture", icon_class: "fa-photo", url: usman.docs_api_v1_upload_profile_picture_path, text: "Upload Profile Picture"},
            delete_profile_picture: { nav_class: "docs/usman/delete_profile_picture", icon_class: "fa-photo", url: usman.docs_api_v1_delete_profile_picture_path, text: "Remove Profile Picture"}
          }
        end

        def set_tab_items
          @tab_items = {
            usman: { nav_class: "docs/usman", icon_class: "fa-group", url: usman.docs_api_v1_register_path, text: "User APIs"}
          }
        end

        def breadcrumb_home_path
          usman.dashboard_path
        end

        def breadcrumbs_configuration
          {
            heading: "Usman - API Documentation",
            description: "A brief documentation of all APIs implemented in the gem Usman with input and output details and examples",
            links: []
          }
        end

      end
    end
  end
end
