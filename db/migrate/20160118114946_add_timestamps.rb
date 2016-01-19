class AddTimestamps < ActiveRecord::Migration
  def change
    add_column :season_indications, :created_at, :datetime
    add_column :season_indications, :updated_at, :datetime

    add_column :seasons, :created_at, :datetime
    add_column :seasons, :updated_at, :datetime

    add_column :plants, :created_at, :datetime
    add_column :plants, :updated_at, :datetime

  end
end
