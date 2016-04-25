class AddAttachmentFileToScrapRecords < ActiveRecord::Migration
  def self.up
    change_table :scrap_records do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :scrap_records, :file
  end
end
