module Types
  class MutationType < Types::BaseObject
    field :add_user, mutation: Mutations::AddUser
    field :delete_squeak, mutation: Mutations::DeleteSqueak
    field :add_squeak, mutation: Mutations::AddSqueak
    field :update_squeak, mutation: Mutations::UpdateSqueak
  end
end
