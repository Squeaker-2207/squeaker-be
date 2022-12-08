module ScoreFetcher
  def self.fetch_score(squeak)
    PerspectiveFacade.content_score(squeak)
  end
end
