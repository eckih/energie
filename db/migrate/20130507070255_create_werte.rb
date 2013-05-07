class CreateWerte < ActiveRecord::Migration
  def change
    create_table :werte do |t|
      t.float :stand
      t.integer :typ
      t.integer :zaehler_id

      t.timestamps
    end
  end
end
