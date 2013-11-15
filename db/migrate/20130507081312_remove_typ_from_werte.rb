class RemoveTypFromWerte < ActiveRecord::Migration
  def up
    remove_column :werte, :typ
  end

  def down
    add_column :werte, :typ, :integer
  end
end
