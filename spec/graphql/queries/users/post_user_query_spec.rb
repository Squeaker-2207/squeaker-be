require 'rails_helper'

module Queries  
  module Users 
    RSpec.describe 'Fetch User Post Request', :vcr, type: :request do
      let(:user) { create(:user) }

      it 'makes successful post request when fetching user' do
        post graphql_path, params: { query: query(id: user.id) }

        expect(response.status).to eq(200)
      end

      it 'has sad path if user is not found' do
        post graphql_path, params: { query: query(id: 99999) }

        json = JSON.parse(response.body, symbolize_names: true)

        error_message = json[:errors][0][:message]

        expect(error_message).to eq("User with id 99999 not found.")
      end

      it 'returns expected user data' do
        post graphql_path, params: { query: query(id: user.id) }

        json = JSON.parse(response.body, symbolize_names: true)

        user_data = json[:data][:fetchUser]

        expect(user_data[:id].to_i).to eq(user.id)
        expect(user_data[:username]).to eq(user.username)
        expect(user_data[:isAdmin]).to eq(user.is_admin)
      end

      def query(id:)
        <<~GQL
          query {
            fetchUser(id: "#{id}") {
              id
              username
              isAdmin
            }
          }
        GQL
      end
    end
  end
end