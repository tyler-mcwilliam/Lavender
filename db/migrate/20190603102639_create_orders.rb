class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.float :price
      t.integer :quantity
      t.string :ticker
      t.boolean :buy
      t.references :poll, foreign_key: true
      t.references :position, foreign_key: true

      t.timestamps
    end
  end
end
