class RemoveTypFromZaehlers < ActiveRecord::Migration
  def up
    remove_column :zaehlers, :typ
  end

  def down
    add_column :zaehlers, :typ, :integer
  end
end
