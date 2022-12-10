require 'rails_helper'

RSpec.describe 'Squeaks Query', :vcr do
  let(:user) { create(:user) }
  let(:squeaks) { create_list(:squeak, 10, user_id: user.id) }

  it 'returns a list of squeaks' do
    query = <<~GQL
      query {
        allSqueaks {
          id
          content
          reports
          nuts
          approved
          user {
            username
          }
          createdAt
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { all_squeaks: squeaks })

    expect(result.dig("data")).to be_a(Hash)
    expect(result.dig("data", "allSqueaks")).to be_a(Array)

    result.dig("data", "allSqueaks").each do |squeak|
      expect(squeak["id"]).to be_a(String)
      expect(squeak["content"]).to be_a(String)
      expect(squeak["reports"]).to be_a(Integer)
      expect(squeak["nuts"]).to be_an(Integer)
      expect(squeak["approved"]).to be_in([true, false])
      expect(squeak["user"]).to be_a(Hash)
      expect(squeak["createdAt"]).to be_a(String)
    end
  end

  it 'returns error if incorrect field is passed' do
    query = <<~GQL
      query {
        allSqueaks {
          date_of_birth
        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { all_squeaks: squeaks })

    expect(result.dig("errors", 0, "message")).to eq("Field 'date_of_birth' doesn't exist on type 'Squeak'")
  end

  it 'returns error if no fields are passed' do
    query = <<~GQL
      query {
        allSqueaks {

        }
      }
    GQL

    result = SqueakrBeSchema.execute(query, context: { all_squeaks: squeaks })

    expect(result.dig("errors", 0, "message")).to eq("Parse error on \"}\" (RCURLY) at [4, 3]")
  end
end
