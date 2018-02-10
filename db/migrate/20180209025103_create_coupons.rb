class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.references :poster, null: false
      t.references :brand, null: false
      t.decimal :value, null: false
      t.boolean :transferred, default: false
      t.timestamps
    end
  end
end
