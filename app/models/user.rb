class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, :date_of_birth, presence: true

  has_one_attached :profile_picture, dependent: :destroy
  validates :profile_picture, content_type: [:png, :jpg, :jpeg]
  
  has_secure_password
end
