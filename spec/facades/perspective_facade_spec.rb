require 'rails_helper'

RSpec.describe PerspectiveFacade, :vcr do
  let(:squeak1) { create(:squeak) }

  it 'provides a score for squeak content' do
    score = PerspectiveFacade.content_score(squeak1)

    expect(score.metric).to be_a String
    expect(score.metric).to eq('IDENTITY_ATTACK')
    expect(score.probability).to be_a Float
  end
end
