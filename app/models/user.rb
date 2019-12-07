class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :name, presence: true
end

