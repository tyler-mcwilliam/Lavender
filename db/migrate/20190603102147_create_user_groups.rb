class CreateUserGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_groups do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.float :user_contribution, default: 0
      t.integer :user_share, default: 0
      t.float :user_balance, default: 0

      t.timestamps
    end
  end
end
