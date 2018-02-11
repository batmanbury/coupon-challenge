class AddUserNamesToTransfers < ActiveRecord::Migration[5.1]
  def change
    add_column :transfers, :poster_name, :string
    add_column :transfers, :requester_name, :string
  end
end
