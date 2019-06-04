class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :photo, :string
    add_column :users, :available_balance, :float
    add_column :users, :total_balance, :float
    add_column :users, :address, :string
  end
end
