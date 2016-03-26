class AddSourceToScrapRecords < ActiveRecord::Migration
  def change
    add_column :scrap_records, :source, :string
  end
end
