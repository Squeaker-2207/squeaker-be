class PerspectiveFacade
  def self.content_score(squeak)
    content_score = PerspectiveService.post_probability(squeak.content)[:attributeScores]
      Score.new(content_score)
  end
end
