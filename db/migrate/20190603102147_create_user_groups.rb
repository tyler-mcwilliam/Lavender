class CreateUserGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_groups do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :user_contribution_cents, null: false, default: 0
      t.integer :user_share, null: false, default: 0
      t.integer :user_balance_cents, null: false, default: 0

      t.timestamps
    end
  end
end
