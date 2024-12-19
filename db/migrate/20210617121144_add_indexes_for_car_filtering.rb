class AddIndexesForCarFiltering < ActiveRecord::Migration[7.0]
  def change
    add_index :cars, :price
    add_index :brands, 'LOWER(name)'
  end
end