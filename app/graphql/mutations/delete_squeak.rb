module Mutations
  class DeleteSqueak < Mutations::BaseMutation 
    argument :id, ID, required: true

    field :squeak, Types::SqueakType, null: false

    def resolve(id:)
      squeak = Squeak.find(id)
      if squeak
        Squeak.destroy(id)
        { squeak: squeak }
      end
      rescue ActiveRecord::RecordNotFound => e 
        GraphQL::ExecutionError.new(e)
    end
  end
end