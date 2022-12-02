# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :username, Types::StringType, null: false
    field :is_admin, Types::BooleanType, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
