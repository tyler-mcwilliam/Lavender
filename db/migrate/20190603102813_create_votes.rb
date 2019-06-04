class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.float :voting_power
      t.boolean :approve
      t.references :user, foreign_key: true
      t.references :poll, foreign_key: true

      t.timestamps
    end
  end
end
