class User < ApplicationRecord
  has_many :transfers
  has_many :posted_coupons, class_name: 'Coupon', foreign_key: 'poster_id'
  has_many :requested_coupons, through: :transfers, source: :coupon, foreign_key: 'requester_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def request_coupon(coupon)
    successful = Transfer.attempt(coupon, self)
  end

  def deduct_from_balance(coupon)
    raise 'insufficient_funds' if coupon.value > balance
    balance -= coupon.value
    save!
  end

  def credit_to_balance(amount)
    # Transfer fee handled in transfer.rb
    self.balance += amount
    save!
  end
end
