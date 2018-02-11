class User < ApplicationRecord
  has_many :transfers
  has_many :posted_coupons, class_name: 'Coupon', foreign_key: 'poster_id'
  has_many :requested_coupons, class_name: 'Coupon', foreign_key: 'requester_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  InsufficientFunds = Class.new(StandardError)

  def deduct_from_balance(amount)
    if amount > balance
      raise InsufficientFunds.new('Your balance is too low to request this coupon.')
    else
      self.balance -= amount
      save!
    end
  end

  def credit_to_balance(amount)
    # Transfer fee handled in CouponTransferService
    self.balance += amount
    save!
  end

  def usd_balance
    format("$%.2f", self.balance)
  end
end
