class Score
  attr_reader :metric, :probability

  def initialize(data)
    @metric = data.keys[0].to_s
    @probability = data[:IDENTITY_ATTACK][:summaryScore][:value]
  end
end
