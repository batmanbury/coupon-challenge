class CouponTransferService
  include ActiveModel::Validations
  PosterRequesterConflict = Class.new(StandardError)

  def initialize(coupon, requester)
    @coupon = coupon
    @requester = requester
  end

  def self.transfer!(coupon, requester)
    new(coupon, requester).transfer!
  end

  def transfer!
    if @requester == @coupon.poster
      raise PosterRequesterConflict.new('You cannot request your own coupon.')
    end
    # Deduct coupon value from requester's balance
    if @requester.deduct_from_balance(@coupon.value)
      # Credit coupon value to poster's balance minus fee
      poster = @coupon.poster
      commission_amount = @coupon.value * Transfer::TRANSACTION_FEE_PERCENT
      credit_amount = @coupon.value - commission_amount
      poster.credit_to_balance(credit_amount)
      # Now safe to record transfer
      Transfer.create!(
        coupon_id: @coupon.id,
        poster_id: @coupon.poster.id,
        requester_id: @requester.id,
        commission_amount: commission_amount
      )
      @coupon.transfer!
    end
  rescue User::InsufficientFunds => e
    errors.add :requester, e.message
    false
  rescue PosterRequesterConflict => e
    errors.add :poster, e.message
    false
  end
end
