module Types
  class ScoreType < Types::BaseObject
    field :id, ID, null: true
    field :metric, String 
    field :probability, Float
  end
end
