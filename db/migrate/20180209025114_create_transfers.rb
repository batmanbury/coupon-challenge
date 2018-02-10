class CreateTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfers do |t|
      t.references :poster, null: false
      t.references :requester, null: false
      t.references :coupon, null: false
      t.timestamps
    end
  end
end
