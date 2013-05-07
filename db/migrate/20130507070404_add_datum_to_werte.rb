class AddDatumToWerte < ActiveRecord::Migration
  def change
    add_column :werte, :datum, :date
  end
end
