require 'rails_helper'

RSpec.describe 'Reported Squeaks Query', :vcr do
  let(:squeaks) { create_list(:squeak, 10) }

  it 'retrieves squeaks that have been reported' do
    query = <<~GQL
      query {
        reportedSqueaks {
          id
          content
          reports
          nuts
          approved
          score {
            metric
            probability
          }
          user {
            username
          }
          createdAt
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { reported_squeaks: squeaks }).as_json

    expect(result['data']).to be_a Hash
    expect(result['data']['reportedSqueaks']).to be_an Array

    result['data']['reportedSqueaks'].each do |squeak|
      expect(squeak['id']).to be_a String
      expect(squeak['content']).to be_a String
      expect(squeak['reports']).to be_an Integer
      expect(squeak['nuts']).to be_an Integer
      expect(squeak['approved']).to be_in([true, false])
      expect(squeak['score']).to be_a Hash
      expect(squeak['score']['metric']).to be_a String
      expect(squeak['score']['metric']).to eq('IDENTITY_ATTACK')
      expect(squeak['score']['probability']).to be_a Float
      expect(squeak['user']).to be_a Hash
      expect(squeak['createdAt']).to be_a String
    end
  end

  it 'returns error if incorrect field is passed' do
    query = <<~GQL
      query {
        reportedSqueaks {
          date_of_birth
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { reported_squeaks: squeaks }).as_json

    expect(result['errors'][0]['message']).to eq("Field 'date_of_birth' doesn't exist on type 'Squeak'")
  end

  it 'returns error if no fields are passed' do
    query = <<~GQL
      query {
        reportedSqueaks {

        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { reported_squeaks: squeaks }).as_json

    expect(result['errors'][0]['message']).to eq("Parse error on \"}\" (RCURLY) at [4, 3]")
  end
end
