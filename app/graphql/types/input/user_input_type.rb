module Types
  module Input
    class UserInputType < Types::BaseInputObject
      argument :username, String, required: true
      argument :is_admin, Boolean, required: true 
    end
  end
end