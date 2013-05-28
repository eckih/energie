class AddFaktorToZaehlers < ActiveRecord::Migration
  def change
    add_column :zaehlers, :faktor, :integer
  end
end
