module Queries
  class ReportedSqueaks < Queries::BaseQuery

    type [Types::SqueakType], null: false

    def resolve
      reports = Squeak.reported
    end
  end
end
