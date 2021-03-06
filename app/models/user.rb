class User < ApplicationRecord
  include Rails.application.routes.url_helpers
  validates :email, presence: true, uniqueness: true
  validates :name, :date_of_birth, presence: true

  has_many :executors, dependent: :destroy
  has_many :recipients, dependent: :destroy
  has_one_attached :profile_picture, dependent: :destroy
  validates :profile_picture, content_type: [:png, :jpg, :jpeg]
  has_many_attached :images, dependent: :destroy
  validates :images, content_type: [:png, :jpg, :jpeg]

  has_secure_password

  def profile_picture_url
    Rails.application.routes.url_helpers.url_for(profile_picture) if profile_picture.attached?
  end

  def images_urls
    if images.attached?
      images.map do |image|
        Rails.application.routes.url_helpers.url_for(image)
      end
    end
  end
end
