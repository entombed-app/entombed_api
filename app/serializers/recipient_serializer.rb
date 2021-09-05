class RecipientSerializer
    include JSONAPI::Serializer
    attributes :email, :name
  end
  