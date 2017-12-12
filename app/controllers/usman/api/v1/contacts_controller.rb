module Usman
  module Api
    module V1
      class ContactsController < Usman::Api::V1::BaseController

        def sync
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                contacts = []
                params[:contacts].each do |cnt|
                  formatted_number = cnt["contact_number"].gsub(' ','').gsub('(','').gsub(')','').gsub('-','').strip
                  contact = Usman::Contact.where("contact_number = ?", formatted_number).first || Usman::Contact.where("email = ?", cnt["email"]).first || Usman::Contact.new
                  
                  contact.name = cnt["name"] unless cnt["name"].blank?
                  contact.account_type = cnt["account_type"] unless cnt["account_type"].blank?
                  contact.email = cnt["email"] unless cnt["email"].blank?
                  contact.contact_number = cnt["contact_number"] unless cnt["contact_number"].blank?
                  
                  contact.owner = @current_user
                  contact.done_deal_user = contact.get_done_deal_user
                  contact.registration = @current_registration
                  contact.device = @current_device

                  contact.save
                  contacts << contact if contact.done_deal_user_id
                end

                @success = true
                @alert = {
                  heading: I18n.translate("api.contacts.synced_successfully.heading"),
                  message: I18n.translate("api.contacts.synced_successfully.message")
                }
                @data = ActiveModelSerializers::SerializableResource.new(contacts, each_serializer: ContactSerializer)
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

        def index
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                @contacts = @current_user.contacts.page(@current_page).per(@per_page)
                @success = true
                @data = ActiveModelSerializers::SerializableResource.new(@contacts, each_serializer: ContactSerializer)
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

        def show
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                @contact = @current_user.contacts.where(id: params[:id]).first || @current_user.contacts.build
                @success = true
                @data = ActiveModelSerializers::SerializableResource.new(@contact, serializer: ContactSerializer)
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

