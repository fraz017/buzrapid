class AddImportExportAndLocationAndSourceToExcelDatum < ActiveRecord::Migration
  def change
    add_column :excel_data, :import_export, :string
    add_column :excel_data, :location, :string
    add_column :excel_data, :source, :string
  end
end
