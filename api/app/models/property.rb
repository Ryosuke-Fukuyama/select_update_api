class Property < ApplicationRecord
  belongs_to :user
  has_one :label, dependent: :destroy
end
