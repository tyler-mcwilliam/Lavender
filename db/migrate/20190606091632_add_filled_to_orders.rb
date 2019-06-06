class AddFilledToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :filled, :boolean
    remove_reference :orders, :position, index: true, foreign_key: true
  end
end
