require 'rails_helper'

module Mutations
  module Users
    RSpec.describe AddUser, type: :request do
      describe '::resolve' do
        it 'adds a user' do
          expect(User.count).to eq 0
          post '/graphql', params: { query: query }
          expect(User.count).to eq 1
        end

        it 'returns a user' do
          post '/graphql', params: { query: query }
          json = JSON.parse(response.body)
          data = json['data']

          expect(data['addUser']['user']['username']).to eq('Test_User')
        end

        it 'returns an error if no username is entered' do
          post '/graphql', params: { query: empty_query }
          json = JSON.parse(response.body)

          result = json['data']['addUser']
          message = json['errors'][0]['message']

          expect(result).to be_nil
          expect(message).to eq("Username can't be blank")
        end

        it 'returns an error if bad parameters are passed' do
          post '/graphql', params: { query: invalid_query }
          json = JSON.parse(response.body)

          result = json['data']
          message = json['errors'][0]['message']

          expect(result).to be_nil
          expect(message).to eq("Argument 'username' on InputObject 'UserInput' is required. Expected type String!")
        end
      end

      def query
        <<~GQL
          mutation {
            addUser(input: { params: { username: "Test_User", isAdmin: false } }) {
              user {
                id
                username
                isAdmin
              }
            }
          }
        GQL
      end

      def empty_query
        <<~GQL
          mutation {
            addUser(input: { params: { username: "", isAdmin: false } }) {
              user {
                id
                username
                isAdmin
              }
            }
          }
        GQL
      end

      def invalid_query
        <<~GQL
          mutation {
            addUser(input: { params: { unicorns: "are not real", isAdmin: false } }) {
              user {
                id
                username
                isAdmin
              }
            }
          }
        GQL
      end
    end
  end
end
