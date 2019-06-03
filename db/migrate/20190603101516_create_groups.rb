class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :photo
      t.text :description
      t.float :portfolio_value
      t.float :cash_value
      t.float :investment_value
      t.integer :total_shares
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
