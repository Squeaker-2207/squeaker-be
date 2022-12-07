class PerspectiveFacade
  def self.content_score(squeak)
    content_score = PerspectiveService.post_probability(squeak.content)[:attributeScores]
      Score.new(content_score)
    # = {
    #   metric: content_score.keys[0].to_s,
    #   probability: content_score[:IDENTITY_ATTACK][:summaryScore][:value]
    # }
  end
end
