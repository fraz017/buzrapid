class CreateAdminDbs < ActiveRecord::Migration
  def change
    create_table :admin_dbs do |t|
    	t.string :com_name
      t.string :com_type
      t.date :purchase_date
      t.string :company_type
      t.integer :quantity
      t.float :purchase_unit
      t.float :est_price_soft
      t.float :est_price_pp
      t.float :market_value
      t.string :exp_life
      t.string :values_used
      t.date :date_purchase
      t.string :remain_life
      t.string :inflation
      t.string :obsolete
      t.float :final_value
      t.integer :project_id
      t.string :import_export
	    t.string :location
	    t.string :source
	    
      t.timestamps null: false
    end
  end
end
