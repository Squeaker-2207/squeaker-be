require 'rails_helper'

RSpec.describe 'Add Squeak Mutation' do
  it 'adds a squeak' do
    user = create(:user)
    query = <<~GQL
    mutation {
      addSqueak(input: { user_id: #{user.id}, content: "I enjoy sledding because I am a normal human child and not a robot. Beep Boop. Oh no" }) {
        squeak {
          id
          content
          user_id
        }
      }
    }
    GQL

    result = SqueakrBeSchema.execute(query)
    expect(result).to be_an Hash
  end
end
