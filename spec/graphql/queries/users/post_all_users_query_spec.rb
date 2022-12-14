require 'rails_helper'

module Queries
  module Users
    RSpec.describe 'Post Request for All Users', :vcr, type: :request do
      let(:users) { create_list(:user, 5) }

      it 'makes successful post request when fetching all users' do
        post graphql_path, params: { query: query }

        expect(response.status).to eq(200)
      end

      it 'has expected data for all users' do
        post graphql_path, params: { query: query, context: { fetch_users: users } }

        json = JSON.parse(response.body, symbolize_names: true)

        users_data = json[:data][:fetchUsers]

        users_data.each do |user|
          expect(user[:id]).to be_a(String)
          expect(user[:username]).to be_a(String)
          expect(user[:isAdmin]).to eq(false)
        end
      end

      it 'returns empty array if no users are found' do
        post graphql_path, params: { query: query }

        json = JSON.parse(response.body, symbolize_names: true)

        users_data = json[:data][:fetchUsers]

        expect(users_data).to eq([])
      end

      def query
        <<~GQL
          query {
            fetchUsers {
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