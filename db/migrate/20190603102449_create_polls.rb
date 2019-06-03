class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.text :description
      t.float :approval
      t.float :target_price
      t.float :stop_loss_price
      t.boolean :buy
      t.integer :quantity
      t.float :price
      t.datetime :expiration
      t.string :ticker
      t.references :group, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }
      t.references :position, foreign_key: true

      t.timestamps
    end
  end
end
