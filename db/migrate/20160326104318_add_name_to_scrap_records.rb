class AddNameToScrapRecords < ActiveRecord::Migration
  def change
    add_column :scrap_records, :name, :string
  end
end
