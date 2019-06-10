class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :is_female, :boolean, default: false
    add_column :users, :photo, :string
    # add_monetize :users, :available_balance, null: false, default: 0
    add_monetize :users, :total_balance, null: false, default: 0, currency: { present: false }
    add_monetize :users, :available_balance, null: false, default: 0, currency: { present: false }
    add_column :users, :address, :string
  end
end
