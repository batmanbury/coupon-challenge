class Transfer < ApplicationRecord
  has_one :coupon
  belongs_to :poster,    class_name: 'User'
  belongs_to :requester, class_name: 'User'

  TRANSACTION_FEE_PERCENT = 0.05
end
