module Mutations
  class AddSqueak < Mutations::BaseMutation
    argument :params, Types::Input::SqueakInputType, required: true

    field :squeak, Types::SqueakType, null: false

    def resolve(params:)
      params = Hash params
      squeak_content = params[:content]
      user_id = params[:user_id]
      user = User.find(user_id)
      begin
        squeak = user.squeaks.new(content: squeak_content)
      end
      squeak.save
      { squeak: squeak }
    end
  end
end