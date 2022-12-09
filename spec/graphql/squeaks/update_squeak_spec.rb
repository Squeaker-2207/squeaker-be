require 'rails_helper'

RSpec.describe 'Update Squeak Mutation' do
  before(:each) do
    @user = create(:user)
    @squeak = create(:squeak, id: 1, user: @user, reports: 0, nuts: 1)
  end
  describe "reporting a squeak" do
    before(:each) do
      @query = <<~GQL
      mutation {
        updateSqueak(input: { id: 1, report: true }) {
          squeak {
            id
            content
            reports
            score{
              metric
              probability
            }
          }
        }
      }
      GQL
    end
    it 'can add a report to a squeak' do
      expect(@squeak.reports).to eq(0)
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("reports")).to eq(1)
      expect(squeak_return.dig("id")).to eq(@squeak.id.to_s)
      expect(squeak_return.dig("content")).to eq(@squeak.content)
      expect(result.dig("data", "updateSqueak", "squeak", 'id')).to be_a(String)
    end

    it 'after a squeak is reported, it is assigned a perspective score set' do
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("score")).to be_an Hash
      expect(squeak_return.dig("score", "metric")).to be_a String
      expect(squeak_return.dig("score", "probability")).to be_a Float
    end

    it "reporting a squeak does not change any other squeak values" do
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("content")).to eq(@squeak.content)
    end

    xit "a user cannot report a squeak more than once " do
      ##requires refactor before possible
      ##repeat previous steps twice to test, requires schema changes to succeed

    end
  end

  describe "nutting a squeak (liking)" do
    before(:each) do
      @query = <<~GQL
      mutation {
        updateSqueak(input: { id: 1, nut: true }) {
          squeak {
            id
            content
            nuts
            }
          }
        }
      GQL
    end

    it 'can add a nut to a squeak' do
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
    end

    it 'does not modify the other values of a squeak when nutting' do

    end

    xit 'cannot nut a squeak more than once' do
      ##currently planning to be handled by front end, best way to handle is described above
    end
  end
end
