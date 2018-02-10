class Transfer < ApplicationRecord
  has_one :coupon
  belongs_to :poster,    class_name: 'User'
  belongs_to :requester, class_name: 'User'

  TRANSACTION_FEE_PERCENT = 0.05

  def self.attempt(coupon, requester)
    # Deduct coupon value from requester's balance
    requester.deduct_from_balance(coupon)
    # Credit coupon value to poster's balance minus fee
    poster = coupon.poster
    credit_amount = coupon.value - (coupon.value * TRANSACTION_FEE_PERCENT)
    poster.credit_to_balance(credit_amount)
    # Now safe to record transfer
    Transfer.create(
      coupon_id: coupon.id,
      poster_id: coupon.poster.id,
      requester_id: requester.id,
    )
  rescue
    return false
  end

end
