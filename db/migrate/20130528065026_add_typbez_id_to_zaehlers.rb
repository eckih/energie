class AddTypbezIdToZaehlers < ActiveRecord::Migration
  def change
    add_column :zaehlers, :typbez_id, :integer
  end
end
