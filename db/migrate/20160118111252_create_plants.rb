class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :dwd_object_id
      t.string :name, null: false
      t.string :filename
    end
  end
end
