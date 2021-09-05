class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :date_of_birth, :obituary, :profile_picture_url

  has_many :executors, serializer: ExecutorSerializer
  has_many :recipients, serializer: RecipientSerializer

  attribute :etd do |object|
    lived_days = (Date.today - object.date_of_birth).to_i
    remaining = ( 44000 - lived_days ).to_i
    max_date = ( Date.today + remaining )
  end
end
