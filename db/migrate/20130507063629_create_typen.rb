class CreateTypen < ActiveRecord::Migration
  def change
    create_table :typen do |t|
      t.string :bezeichnung
      t.string :link

      t.timestamps
    end
  end
end
