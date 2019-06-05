class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :photo
      t.text :description
      t.float :portfolio_value, default: 0
      t.float :cash_value, default: 0
      t.float :investment_value, default: 0
      t.integer :total_shares, default: 0
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
