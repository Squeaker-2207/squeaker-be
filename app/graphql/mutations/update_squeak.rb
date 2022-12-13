module Mutations
  class UpdateSqueak < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :report, Boolean, required: false
    argument :nut, Boolean, required: false
    argument :approved, Boolean, required: false

    field :squeak, Types::SqueakType, null: false

    def resolve(id: , report: false, nut: false, approved: nil)
      squeak = Squeak.find(id)
      if squeak
        check_arguments(squeak, report, nut, approved)
      end
      { squeak: squeak }
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new(e)
    end

    def check_arguments(squeak, report, nut, approved)
      squeak.reports += 1 if report == true
      squeak.nuts += 1 if nut == true

      case approved
      when true
        squeak.approved = true
        squeak.reports = 0
      when false
        squeak.approved = false
      end

      squeak.save
    end
  end
end