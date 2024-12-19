class AddPerformanceIndexes < ActiveRecord::Migration[7.0]
  def change
    # Indexes for filtering
    add_index :cars, :price
    add_index :brands, 'LOWER(name)'
    
    # Indexes for associations
    add_index :cars, :brand_id
    add_index :user_preferred_brands, [:user_id, :brand_id]
    
    # Index for price range queries
    add_index :users, :preferred_price_range, using: :gist
  end
end