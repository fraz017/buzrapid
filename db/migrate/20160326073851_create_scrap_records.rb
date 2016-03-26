class CreateScrapRecords < ActiveRecord::Migration
  def change
    create_table :scrap_records do |t|
      t.string :hs_code
      t.string :desc
      t.string :country
      t.float :price_pp
      t.belongs_to :admin_db
      t.belongs_to :excel_datum
      t.timestamps null: false
    end
  end
end
