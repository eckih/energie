class AddTypIdToZaehlers < ActiveRecord::Migration
  def change
    add_column :zaehlers, :typ_id, :integer
  end
end
