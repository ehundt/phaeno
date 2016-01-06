class AddFilenameToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :filename, :string
  end
end
