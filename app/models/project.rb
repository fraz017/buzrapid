class Project < ActiveRecord::Base
	belongs_to :company
	has_many :excel_datum, :dependent => :destroy
	has_many :admin_dbs, :dependent => :destroy
	has_attached_file :file
  validates_attachment :file, content_type: { content_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
end
