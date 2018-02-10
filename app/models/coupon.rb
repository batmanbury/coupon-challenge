class Coupon < ApplicationRecord
  belongs_to :brand
  belongs_to :poster,    class_name: 'User'
  belongs_to :requester, class_name: 'User', optional: true
  belongs_to :transfer, optional: true

  scope :transferred, -> { where(transferred: true) }
end
