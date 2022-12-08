module Types
  module Input
    class SqueakInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :content, String, required: true
    end
  end
end