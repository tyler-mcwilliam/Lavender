class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.string :ticker
      t.integer :quantity
      t.float :cost_basis
      t.float :current_price
      t.float :return
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
