module Queries
  class FetchUser < Queries::BaseQuery
    type Types::UserType, null: false
    argument :id, String, required: true

    def resolve(id:)
      User.find(id)
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new("User with id #{id} not found.")
    rescue ActiveRecord::RecordInvalid => e 
      GraphQL::ExecutionError.new("Invalid Attributes for #{e.record.class}:"\
      " #{e.record.class.errors.full_messages.join(', ')}")
    end
  end
end