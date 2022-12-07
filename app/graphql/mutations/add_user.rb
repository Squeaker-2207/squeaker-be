module Mutations
  class AddUser < Mutations::BaseMutation 
    argument :params, Types::Input::UserInputType, required: true

    field :user, Types::UserType, null: false

    def resolve(params:)
      user_params = Hash params
      begin 
        user = User.new(user_params)
      end
      user.save
      { user: user }
    end
  end
end