require 'rails_helper'

RSpec.describe 'Update Squeak Mutation', :vcr do
  let(:squeak) { create(:squeak, reports: 0, nuts: 1, approved: nil) }

  describe "reporting a squeak" do
    before(:each) do
      @query = <<~GQL
      mutation {
        updateSqueak(input: { id: "#{squeak.id}", report: true }) {
          squeak {
            id
            content
            reports
            nuts
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
      expect(squeak.reports).to eq(0)
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("reports")).to eq(1)
      expect(squeak_return.dig("id")).to eq(squeak.id.to_s)
      expect(squeak_return.dig("content")).to eq(squeak.content)
      expect(squeak_return.dig("id")).to be_a(String)
    end

    it 'is assigned a score when reported' do
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("score")).to be_an Hash
      expect(squeak_return.dig("score", "metric")).to be_a String
      expect(squeak_return.dig("score", "probability")).to be_a Float
    end

    it "does not change any other squeak values when reported" do
      result = SqueakrBeSchema.execute(@query)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("content")).to eq(squeak.content)
      expect(squeak_return.dig("nuts")).to eq(squeak.nuts)
    end

    xit "a user cannot report a squeak more than once " do
      ##requires refactor before possible
      ##repeat previous steps twice to test, requires schema changes to succeed

    end

    it "raises an error if the squeak cannot be found" do
      query_v2 = <<~GQL
      mutation {
        updateSqueak(input: { id: 1212312312421124, report: true }) {
          squeak {
            id
            content
            reports
            nuts
            score{
              metric
              probability
            }
          }
        }
      }
      GQL
      result = SqueakrBeSchema.execute(query_v2)
      errors = result.dig("errors")
      expect(errors).to be_an Array
      expect(errors.first.dig("message")).to be_a String
      expect(errors.first.dig("path")).to eq(["updateSqueak"])
    end
  end

  describe "nutting a squeak (liking)" do
    before(:each) do
      @query = <<~GQL
      mutation {
        updateSqueak(input: { id: "#{squeak.id}", nut: true }) {
          squeak {
            id
            content
            nuts
            reports
            }
          }
        }
      GQL
    end

    it 'can add a nut to a squeak' do
      expect(squeak.nuts).to eq(1)
      result = SqueakrBeSchema.execute(@query)
      expect(result.dig("data")).to be_a(Hash)
      expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("nuts")).to eq(2)
    end

    it 'does not modify the other values of a squeak when nutting' do
      result = SqueakrBeSchema.execute(@query)
      squeak_return = result.dig("data", "updateSqueak", "squeak")
      expect(squeak_return.dig("content")).to eq(squeak.content)
      expect(squeak_return.dig("reports")).to eq(squeak.reports)
    end

    xit 'cannot nut a squeak more than once' do
      ##currently planning to be handled by front end, best way to handle is described above
    end

    it 'returns an error when the squeak cannot be found' do
      bad_query = <<~GQL
      mutation {
        updateSqueak(input: { id: 1212312312421124, nut: true }) {
          squeak {
            id
            content
            reports
            nuts
            score{
              metric
              probability
            }
          }
        }
      }
      GQL
      result = SqueakrBeSchema.execute(bad_query)
      errors = result.dig("errors")
      expect(errors).to be_an Array
      expect(errors.first.dig("message")).to be_a String
      expect(errors.first.dig("path")).to eq(["updateSqueak"])
    end
  end

  describe 'Admin actions' do
    let(:reported_squeak) { create(:squeak, reports: 5, approved: nil) }

    context 'approve reported squeak' do
      before :each do
        @query = <<~GQL
          mutation {
            updateSqueak(input: { id: "#{reported_squeak.id}", approved: true }) {
              squeak {
                id
                content
                reports
                nuts
                approved
                score{
                  metric
                  probability
                }
              }
            }
          }
        GQL
      end

      it 'updates squeaks approved status to true' do
        expect(reported_squeak.approved).to be_nil

        result = SqueakrBeSchema.execute(@query)
        expect(result.dig("data")).to be_a(Hash)
        expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
        squeak_return = result.dig("data", "updateSqueak", "squeak")
        expect(squeak_return.dig("approved")).to be(true)

        reported_squeak.reload
        expect(reported_squeak.approved).to be(true)
      end

      it 'resets reports count to 0 after approval' do
        result = SqueakrBeSchema.execute(@query)
        expect(result.dig("data")).to be_a(Hash)
        expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
        squeak_return = result.dig("data", "updateSqueak", "squeak")
        expect(squeak_return.dig("reports")).to eq 0

        reported_squeak.reload
        expect(reported_squeak.reports).to eq(0)
      end
    end

    context 'reject reported squeak' do
      it 'updates approved status to false' do
        query = <<~GQL
          mutation {
            updateSqueak(input: { id: "#{reported_squeak.id}", approved: false }) {
              squeak {
                id
                content
                reports
                nuts
                approved
                score{
                  metric
                  probability
                }
              }
            }
          }
        GQL

        result = SqueakrBeSchema.execute(query)
        expect(result.dig("data")).to be_a(Hash)
        expect(result.dig("data", "updateSqueak", "squeak")).to be_a(Hash)
        squeak_return = result.dig("data", "updateSqueak", "squeak")
        expect(squeak_return.dig("approved")).to be(false)

        reported_squeak.reload
        expect(reported_squeak.approved).to be(false)
      end
    end
  end
end
