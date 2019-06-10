class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.string :ticker
      t.integer :quantity, null: false, default: 0
      t.integer :cost_basis_cents
      t.integer :current_price_cents
      t.integer :return_cents
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
