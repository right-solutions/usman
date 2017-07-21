require 'rails_helper'
require 'spec_helper'

RSpec.describe Usman::Api::V1::UsersController, type: :controller do
	describe "userscontroller" do

		let(:user_params) { 
			{
				user: {
					name: "abcd",
					username: "efgh",
					email: "example@yopmail.com",
					phone: "9900445566",
					password: "Password@1",
					password_confirmation: "Password@1"
				}
			}
		}

		context "create action" do
			describe "POST Create positive case" do
				before(:each) do
					@expected_count = 1
					@expected_fusername = "efgh"
					post :create, params: user_params
				end

				it "should create user" do
					parsed_response = JSON.parse(response.body)
					expect(User.count).to  eq(@expected_count)
					expect(User.last.username).to  eq(@expected_fusername)
					expect(parsed_response['success']).to be_truthy
					expect(response).to have_http_status(201)
				end
			end

			describe "POST Create negative case" do
				before(:each) do
					@expected_count = 0
					user_params[:user][:name] = nil
					post :create, params: user_params
				end

				it "should not create user" do
					parsed_response = JSON.parse(response.body)
					expect(User.count).to  eq(@expected_count)
					expect(parsed_response['success']).to be_falsey
					expect(parsed_response['error']).to be_present
					expect(response).to have_http_status(404)
				end
			end
		end
	end
end