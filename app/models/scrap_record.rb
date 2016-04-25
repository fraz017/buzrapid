require 'rubyXL'
require 'crawl'
require 'roo'
class ScrapRecord < ActiveRecord::Base
	has_attached_file :file
  validates_attachment :file, content_type: { content_type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
	def self.import(file)
		workbook = Roo::Excelx.new("#{file.path}")
		(workbook.first_row..workbook.last_row).each_with_index do |r, index|
			if index > 0
				row = workbook.row(r)
				data = ScrapRecord.new 	
    		data.name = row[0].squish 
    		data.country = row[1].squish 
    		data.price_pp = row[2].present? ? row[2].to_f : 0.0
    		data.desc = row[3]  
    		data.source = row[5]  
    		data.save
			end	
		end
	end
end
