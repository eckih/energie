class CreateTypbezs < ActiveRecord::Migration
  def change
    create_table :typbezs do |t|
      t.string :bezeichnung
      t.string :kurzbezeichnung

      t.timestamps
    end
  end
end
