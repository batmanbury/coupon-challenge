class AddRequesterIdToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_reference :coupons, :requester, index: true
  end
end
