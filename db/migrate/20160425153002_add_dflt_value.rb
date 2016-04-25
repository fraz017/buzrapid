class AddDfltValue < ActiveRecord::Migration
  def change
  	change_column :admin_dbs, :final_value, :float, :default => 0.0
  	change_column :excel_data, :final_value, :float, :default => 0.0
  end
end
