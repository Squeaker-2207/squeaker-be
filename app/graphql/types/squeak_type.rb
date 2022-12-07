# frozen_string_literal: true

module Types
  class SqueakType < Types::BaseObject
    field :id, ID, null: false
    field :content, String
    field :reports, Integer
    field :nuts, Integer
    field :approved, Boolean
    field :user, Types::UserType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
