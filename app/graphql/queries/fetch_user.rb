module Queries
  class FetchUser < Queries::BaseQuery
    type Types::UserType, null: false
    argument :id, ID, required: true

    def resolve(id)
      User.find(id)
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new('User with that id not found.')
    rescue ActiveRecord::RecordInvalid => e 
      GraphQL::ExecutionError.new("Invalid Attributes for #{e.record.class}:"\
      " #{e.record.class.errors.full_messages.join(', ')}")
    end
  end
end