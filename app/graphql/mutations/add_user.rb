module Mutations
  class AddUser < Mutations::BaseMutation
    argument :params, Types::Input::UserInputType, required: true

    field :user, Types::UserType, null: false

    def resolve(params:)
      user_params = Hash params
      user = User.new(user_params)
      if user.save
        { user: user }
      else
        raise GraphQL::ExecutionError, user.errors.full_messages.join(', ')
      end
    end
  end
end
