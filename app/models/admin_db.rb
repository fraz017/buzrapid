require 'rubyXL'
class AdminDb < ActiveRecord::Base
	belongs_to :project
	before_save :fill_values
	def self.import(project)
		workbook = RubyXL::Parser.parse project.file.path
		worksheet = workbook[0]
		worksheet.each_with_index do |row, index|
			if index > 1
				data = AdminDb.new 	
    		data.com_name = row[0].value 
	      data.com_type = row[1].value
	      data.purchase_date = row[2].value
	      data.company_type = row[3].value
	      data.quantity = row[4].value
	      data.purchase_unit = row[5].value.present? ? row[5].value.to_f : 0.0
	      data.est_price_soft = row[6].value 
	      data.est_price_pp = row[7].value   
	      data.market_value = row[8].value   
	      data.exp_life = row[9].value
	      data.values_used = row[10].value    
	      data.date_purchase = row[11].value
	      data.remain_life = row[12].value    
	      data.inflation = row[13].value      
	      data.obsolete = row[14].value
	      data.final_value = row[15].value.present? ? row[15].value.to_f : 0.0    
	      data.project_id = project.id
 				data.save	
			end
		end
	end
	private
	def fill_values
		binding.pry
		self.market_value = 150
	end

end
