# frozen_string_literal: true

module Types
  class SqueakType < Types::BaseObject
    implements Types::RecordType
    description 'A squeak'

    field :content, String, null: false, description: 'The text of the squeak'
    field :reports, Integer, description: 'The number of times a squeak has been reported'
    field :nuts, Integer, description: 'The number of nuts/likes a squeak has'
    field :approved, Boolean, description: 'Whether a squeak has been approved by an admin or not'
    field :user, Types::UserType, description: 'The author of the squeak'

  end
end
