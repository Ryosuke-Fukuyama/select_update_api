class Label < ApplicationRecord
  belongs_to :property, optional: true
end
