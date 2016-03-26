class ScrapRecord < ActiveRecord::Base
	belongs_to :excel_datum
	belongs_to :admin_db
end
