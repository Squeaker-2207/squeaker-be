module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :fetch_users, resolver: Queries::FetchUsers
    field :fetch_user, resolver: Queries::FetchUser
    field :all_squeaks, resolver: Queries::AllSqueaks
  end
end
