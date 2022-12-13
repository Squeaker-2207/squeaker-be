require 'rails_helper'

RSpec.describe Squeak, type: :model do
  describe 'validations' do
    it { should belong_to :user }
    it { should validate_presence_of :content }

    xit 'validates that the content passes the Nyckel ML filter' do
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

  describe 'model methods' do
    let(:squeaks) { create_list(:squeak, 3) }
    let(:squeak1) { squeaks.first }

    before :each do 
      create_list(:squeak, 3, approved: nil)
      create_list(:squeak, 3, approved: true)
      create_list(:squeak, 3, approved: false)
    end
    

    describe '::reported' do
      it 'scopes reported squeaks' do
        Squeak.reported.each do |squeak|

          expect(squeak.reports).to be > 0
        end
      end
    end

    describe '::permitted' do 
      it 'scopes squeaks that have not been unapproved by the moderator' do 
        Squeak.permitted.each do |squeak|
          expect(squeak.approved).to eq(true).or eq(nil)
        end
      end
    end

    describe '#score', :vcr do
      it 'provides probability score' do

        expect(squeak1.score.metric).to eq('IDENTITY_ATTACK')
        expect(squeak1.score.probability).to be_a Float
      end
    end
  end
end
