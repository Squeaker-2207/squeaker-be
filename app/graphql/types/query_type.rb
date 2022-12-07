module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :squeaks, SqueakType.connection_type, description: "The list of squeaks"
    field :users, UserType.connection_type, description: "The list of users"

    def squeaks
      Squeak.order(:created_at)
    end

    def users
      User.order(:created_at)
    end
  end
end
