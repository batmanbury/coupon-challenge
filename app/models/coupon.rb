class Coupon < ApplicationRecord
  belongs_to :brand
  belongs_to :poster,    class_name: 'User'
  belongs_to :requester, class_name: 'User', optional: true
  belongs_to :transfer, optional: true

  scope :transferred, -> { where(transferred: true) }
  scope :posted, -> { where(transferred: false) }

  def transfer_to!(requester)
    self.requester_id = requester.id
    self.transferred = true
    save!
  end

  def usd_value
    format("$%.2f", self.value)
  end
end
