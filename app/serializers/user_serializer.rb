class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :date_of_birth, :profile_picture, :obituary

  attribute :etd do |object|
    lived_days = (Date.today - object.date_of_birth).to_i
    remaining = ( 44000 - lived_days ).to_i
    max_date = ( Date.today + remaining )
  end

  def profile_picture
    rails_blob_path(object.profile_picture, only_path: true) if object.profile_picture.attached?
  end
end
