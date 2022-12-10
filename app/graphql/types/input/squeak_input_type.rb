module Types
  module Input
    class SqueakInputType < Types::BaseInputObject
      argument :content, String, required: true
      argument :user_id, String, required: true
    end
  end
end