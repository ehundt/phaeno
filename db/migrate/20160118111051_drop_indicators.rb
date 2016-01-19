class DropIndicators < ActiveRecord::Migration
  def change
    drop_table :indicators
  end
end
