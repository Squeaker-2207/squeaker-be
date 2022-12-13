module Queries
  class AllSqueaks < Queries::BaseQuery

    type [Types::SqueakType], null: false

    def resolve
      Squeak.permitted.order(created_at: :desc)
    end
  end
end
