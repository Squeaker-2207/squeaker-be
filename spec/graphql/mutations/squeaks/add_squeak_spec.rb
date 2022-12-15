require 'rails_helper'

module Mutations
  module Squeaks
    RSpec.describe AddSqueak, :vcr, type: :request do
      let(:user) { create(:user) }
      let(:content) { "Birds are a fiction created by Big Bird Seed" }
      let(:content1) { 'I really love mountain bluebirds' }

      describe '::resolve' do
        it 'adds a squeak' do
          expect(Squeak.count).to eq 0
          post graphql_path, params: { query: query }
          expect(Squeak.count).to eq 1
        end

        it 'returns a squeak' do
          post graphql_path, params: { query: query }
          json = JSON.parse(response.body)
          data = json['data']

          expect(data['addSqueak']['squeak']['id']).to be_a String
          expect(data['addSqueak']['squeak']['content']).to eq('Birds are a fiction created by Big Bird Seed')

          squeak_user = data['addSqueak']['squeak']['user']

          expect(squeak_user['id'].to_i).to eq(user.id)
          expect(squeak_user['username']).to eq(user.username)
        end

        it 'returns an error if no user cannot be found' do
          post graphql_path, params: { query: no_user_query }
          json = JSON.parse(response.body)

          result = json['data']['addSqueak']
          message = json['errors'][0]['message']

          expect(result).to be_nil
          expect(message).to eq("Couldn't find User with 'id'=999")
        end

        it 'returns an error if bad parameters are passed' do
          post graphql_path, params: { query: invalid_query }
          json = JSON.parse(response.body)

          result = json['data']
          message = json['errors'][0]['message']

          expect(result).to be_nil
          expect(message).to eq("Argument 'content' on InputObject 'SqueakInput' is required. Expected type String!")
        end

        it 'returns an error if squeak is not added' do
          post graphql_path, params: { query: filtered_query }
          json = JSON.parse(response.body)

          result = json['data']
          message = json['errors'][0]['message']

          expect(result).to be_a Hash
          expect(result).to eq({'addSqueak'=>nil})
          expect(result[0]).to be_nil
          expect(message).to eq('Content Hate Speech')
        end
      end

      def query
        <<~GQL
          mutation {
            addSqueak(input: { params: { content: "#{content}", userId: "#{user.id}" } }) {
              squeak {
                id
                content
                user {
                  id
                  username
                }
              }
            }
          }
        GQL
      end

      def no_user_query
        <<~GQL
          mutation {
            addSqueak(input: { params: { content: "#{content}", userId: "999" } }) {
              squeak {
                id
                content
                user {
                  id
                  username
                }
              }
            }
          }
        GQL
      end

      def invalid_query
        <<~GQL
          mutation {
            addSqueak(input: { params: { unicorns: "Are Pretty", userId: "#{user.id}" } }) {
              squeak {
                id
                content
                user {
                  id
                  username
                }
              }
            }
          }
        GQL
      end

      def filtered_query
        <<~GQL
          mutation {
            addSqueak(input: { params: { content: "#{content1}", userId: "#{user.id}" } }) {
              squeak {
                id
                content
                user {
                  id
                  username
                }
              }
            }
          }
        GQL
      end
    end
  end
end
