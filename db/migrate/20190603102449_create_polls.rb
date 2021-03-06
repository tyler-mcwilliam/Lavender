class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.text :description
      t.float :approval, null: false, default: 0
      t.integer :target_price_cents
      t.integer :stop_loss_price_cents
      t.boolean :buy
      t.integer :quantity
      t.integer :price_cents
      t.datetime :expiration
      t.string :ticker
      t.references :group, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }
      t.references :position, foreign_key: true

      t.timestamps
    end
  end
end
