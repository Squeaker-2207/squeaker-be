class Squeak < ApplicationRecord
  belongs_to :user

  # Always eager load user when querying squeaks on the API
  scope :graphql_scope, -> { eager_load(:user) }
end
