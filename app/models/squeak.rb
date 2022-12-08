class Squeak < ApplicationRecord
  belongs_to :user

  scope :reported, -> { where('reports > 0') }

  def score
    ScoreFetcher.fetch_score(self)
  end
end
