class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, :date_of_birth, presence: true

  has_many :images


  has_secure_password
end
