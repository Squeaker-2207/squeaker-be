require 'rails_helper'

RSpec.describe PerspectiveService, :vcr do
  let(:squeak1) { create(:squeak) }

  it 'retrieves metrics for post content' do
    metrics = PerspectiveService.post_probability(squeak1.content)

    expect(metrics).to be_a Hash
    expect(metrics.keys).to eq([:attributeScores, :languages, :detectedLanguages])
    expect(metrics[:attributeScores]).to have_key(:IDENTITY_ATTACK)
    expect(metrics[:attributeScores][:IDENTITY_ATTACK].keys).to eq([:spanScores, :summaryScore])
    expect(metrics[:attributeScores][:IDENTITY_ATTACK][:spanScores]).to be_an Array
      metrics[:attributeScores][:IDENTITY_ATTACK][:spanScores].each do |metric|
        expect(metric.keys).to eq([:begin, :end, :score])
        expect(metric[:begin]).to be_an Integer
        expect(metric[:end]).to be_an Integer
        expect(metric[:score]).to be_a Hash
        expect(metric[:score].keys).to eq([:value, :type])
        expect(metric[:score][:value]).to be_a Float
        expect(metric[:score][:type]).to be_a String
      end
    expect(metrics[:attributeScores][:IDENTITY_ATTACK][:summaryScore].keys).to eq([:value, :type])
    expect(metrics[:attributeScores][:IDENTITY_ATTACK][:summaryScore][:value]).to be_a Float
    expect(metrics[:attributeScores][:IDENTITY_ATTACK][:summaryScore][:type]).to be_a String
    expect(metrics[:languages]).to be_an Array
      metrics[:languages].each do |language|
        expect(language).to be_a String
      end
    expect(metrics[:detectedLanguages]).to be_an Array
      metrics[:detectedLanguages].each do |language|
        expect(language).to be_a String
      end
  end
end
