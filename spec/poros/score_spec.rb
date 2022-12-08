require 'rails_helper'

RSpec.describe Score do
  it 'exists and has attributes' do
    data = {
      :IDENTITY_ATTACK=>
    {:spanScores=>[{:begin=>0, :end=>26, :score=>{:value=>0.0022661188, :type=>"PROBABILITY"}}],
     :summaryScore=>{:value=>0.0022661188, :type=>"PROBABILITY"}}
    }

    score = Score.new(data)

    expect(score.metric).to be_a String
    expect(score.metric).to eq('IDENTITY_ATTACK')
    expect(score.probability).to be_a Float
    expect(score.probability).to eq(0.0022661188)
  end
end
