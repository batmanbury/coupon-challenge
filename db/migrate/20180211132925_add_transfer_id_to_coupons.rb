class AddTransferIdToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_reference :coupons, :transfer, index: true
  end
end
