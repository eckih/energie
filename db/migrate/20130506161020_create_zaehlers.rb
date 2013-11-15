class CreateZaehlers < ActiveRecord::Migration
  def change
    create_table :zaehlers do |t|
      t.integer :nummer
      t.integer :typ
      t.string :bezeichnung
      t.string :kurzbezeichnung
      t.string :standort
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
