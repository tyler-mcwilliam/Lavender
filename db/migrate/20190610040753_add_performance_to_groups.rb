class AddPerformanceToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :performance, :text
  end
end
