class User < ApplicationRecord
  has_many :propertes, dependent: :destroy
end
