class AddDatumToValues < ActiveRecord::Migration
  def change
    add_column :values, :datum, :date
  end
end
