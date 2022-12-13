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

  describe 'model methods', :vcr do
    let(:squeaks) { create_list(:squeak, 5) }

    describe '::reported' do
      it 'scopes reported squeaks' do
        squeaks
        Squeak.reported.each do |squeak|

          expect(squeak.approved).to eq(true).or eq(nil)
          expect(squeak.approved).to_not eq(false)
          expect(squeak.reports).to be > 0
        end
      end
    end

    describe '::permitted' do
      it 'scopes squeaks that have not been unapproved by the moderator' do
        squeaks
        Squeak.permitted.each do |squeak|

          expect(squeak.approved).to eq(true).or eq(nil)
          expect(squeak.approved).to_not eq(false)
        end
      end
    end

    describe '#score' do
      it 'provides probability score' do
        squeaks
        Squeak.reported.each do |squeak|

          expect(squeak.approved).to eq(true).or eq(nil)
          expect(squeak.approved).to_not eq(false)
          expect(squeak.score.metric).to eq('IDENTITY_ATTACK')
          expect(squeak.score.probability).to be_a Float
        end
      end
    end
  end
end
