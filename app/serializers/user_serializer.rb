class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :date_of_birth, :obituary, :profile_picture

  has_many :executors, serializer: ExecutorSerializer

  attribute :etd do |object|
    lived_days = (Date.today - object.date_of_birth).to_i
    remaining = ( 44000 - lived_days ).to_i
    max_date = ( Date.today + remaining )
  end

  attribute :profile_picture do |object| 
    Rails.application.routes.url_helpers.rails_blob_url(object.profile_picture) if object.profile_picture.attached?
  end
end
