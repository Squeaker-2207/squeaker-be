module Mutations
  class UpdateSqueak < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :report, Boolean, required: false
    argument :nut, Boolean, required: false
    argument :approve, Boolean, required: false

    field :squeak, Types::SqueakType, null: false

    def resolve(id: , report: false, nut: false, approve: nil)
      squeak = Squeak.find(id)
      if squeak
        if report == true
          squeak.reports += 1
        elsif nut == true
          squeak.nuts += 1
        elsif approve == true
          squeak.approved = true
          squeak.reports = 0
        end
        squeak.save
      end
      { squeak: squeak }
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
    end
  end
end