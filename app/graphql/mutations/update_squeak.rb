module Mutations
  # Update attributes on a squeak
  class UpdateSqueak < BaseMutation
    # Require an ID to be provided
    argument :id, ID, required: true

    # Allow the following fields to be updated. Each is optional.
    argument :nuts, Integer, required: false
    argument :reports, String, required: false
    argument :approved, Boolean, required: false

    # Return fields. A standard approach is to return the mutation
    # state (success & errors) as well as the updated object.
    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :squeak, Types::SqueakType, null: true

    # Mutation logic and return value. 
    #
    # The rest of the keyword arguments are directly
    # passed to the update method. Because GraphQL is strongly typed we
    # know the rest of the arguments are safe to pass directly to the
    # update method (= in the list of accepted arguments)
    def resolve(id:, **args)
      record = Squeak.find(id)

      if record.update(args)
        { success: true, squeak: record, errors: [] }
      else
        { success: false, squeak: nil, errors: record.errors.full_messages }
      end
    rescue ActiveRecord::RecordNotFound
      return { success: false, squeak: nil, errors: ['record-not-found'] }
    end
  end
end