class Squeak < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  # validate :filter

  scope :reported, -> { permitted.where('reports > 0') }
  scope :permitted, -> { where('approved != false') }

  def score
    ScoreFetcher.fetch_score(self)
  end

  # def filter
  #   label = NyckelService.get_label(self.content)
  #   if label[:labelName] == 'Hate Speech' && label[:confidence] > 0.8
  #     self.errors.add(:content, label[:labelName])
  #   end
  # end
end
