require 'rails_helper'

RSpec.describe Squeak, type: :model do
  describe 'validations' do
    it { should belong_to :user }
    it { should validate_presence_of :content }

    it 'validates that the content passes the Nyckel ML filter' do 
      new_squeak = build(:squeak)
      nyckel_response = {
        :labelName=>"Hate Speech", 
        :labelId=>"label_qhgwk715xapwes32", 
        :confidence=>0.85
      }

      allow(NyckelService).to receive(:get_label).and_return(nyckel_response)

      expect(new_squeak.save).to be false
      expect(new_squeak.errors.messages.first).to eq([:content, ["Hate Speech"]])
    end
  end

  describe 'model methods', :vcr do
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
