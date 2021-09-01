class ExecutorSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :phone
end
