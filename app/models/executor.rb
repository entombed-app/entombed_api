class Executor < ApplicationRecord
  belongs_to :user
  validates :name, :email, presence: true
end
