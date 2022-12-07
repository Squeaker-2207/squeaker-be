require 'rails_helper'

RSpec.describe Squeak, type: :model do
  describe 'validations' do
    it { should belong_to :user }
  end

  describe 'model methods' do
    let(:squeaks) { create_list(:squeak, 3) }
    let(:squeak1) { squeaks.first }
    let(:squeak2) { squeaks.second }
    let(:squeak3) { squeaks.third }

    describe '#reported' do
      it 'scopes reported squeaks' do
        Squeak.reported.each do |squeak|

          expect(squeak.reports).to be > 0
        end
      end
    end

    describe '.score', :vcr do
      it 'provides probability score' do

        expect(squeak1.score.metric).to eq('IDENTITY_ATTACK')
        expect(squeak1.score.probability).to be_a Float
      end
    end
  end
end
