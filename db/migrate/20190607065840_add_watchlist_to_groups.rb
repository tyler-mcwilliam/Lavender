class AddWatchlistToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :watchlist, :text, array: true, default: ['AAPL', 'GE', 'F', 'MSFT', 'AMD', 'FIT', 'GPRO', 'FB', 'TWTR', 'NFLX']
  end
end
