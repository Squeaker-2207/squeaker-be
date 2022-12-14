module Mutations
  class AddSqueak < Mutations::BaseMutation
    argument :params, Types::Input::SqueakInputType, required: true

    field :squeak, Types::SqueakType, null: false

    def resolve(params:)
      params = Hash params
      begin
        user = User.find(params[:user_id])
        squeak = Squeak.new(content: params[:content], user_id: user.id)
      rescue ActiveRecord::RecordNotFound => e
        raise GraphQL::ExecutionError, e.message
      end
      if squeak.save
        { squeak: squeak }
      else
        raise GraphQL::ExecutionError, squeak.errors.full_messages.join(', ')
      end
    end
  end
end
