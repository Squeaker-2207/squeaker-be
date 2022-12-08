require 'rails_helper'

RSpec.describe NyckelService, :vcr do
  let(:squeak1) { create(:squeak) }

  it 'retrieves a label for post content' do
    moderated = NyckelService.get_label(squeak1.content)

    expect(moderated.keys).to eq([:labelName, :labelId, :confidence])
    expect(moderated[:labelName]).to be_a String
    expect(moderated[:labelId]).to be_a String
    expect(moderated[:confidence]).to be_a Float
  end
end
