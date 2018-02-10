class Brand < ApplicationRecord
  has_many :coupons

  validates_uniqueness_of :name
end
