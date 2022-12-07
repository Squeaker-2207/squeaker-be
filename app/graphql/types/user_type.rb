# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements Types::RecordType
    description 'A user'
    
    field :username, String, null: false, description: 'The username of the user'
    field :is_admin, Boolean, description: 'Whether the user is an admin'
  end
end
