class AddCommissionAmountToTransfers < ActiveRecord::Migration[5.1]
  def change
    add_column :transfers, :commission_amount, :decimal, null: false
  end
end
