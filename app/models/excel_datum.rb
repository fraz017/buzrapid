require 'rubyXL'
class ExcelDatum < ActiveRecord::Base
	belongs_to :project
	before_save :fill_values
	def self.import(project)
		workbook = RubyXL::Parser.parse project.file.path
		worksheet = workbook[0]
		worksheet.each_with_index do |row, index|
			if index > 1
				data = ExcelDatum.new 	
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
		if self.est_price_soft.blank?
			begin
				check = AdminDb.where(:com_name => self.com_name).last
				if check.present?
					self.est_price_soft = check.est_price_soft
				end
			rescue 
				''
			end
		end
		if self.est_price_pp.blank?
			begin
				check = ExcelDatum.where(:com_name => self.com_name).last
				if check.present?
					self.est_price_pp = check.est_price_pp
				end	
			rescue 
				''
			end
		end
		if self.remain_life.blank?
			begin
				if self.purchase_date.present?
					diff = self.exp_life-(((Date.today-self.purchase_date.to_date).to_i)/365.0)
					self.remain_life = diff
				end	
			rescue 
				''
			end
		end
		if self.inflation.blank?
			begin
				inflation_factor = self.project.inflation
				obsolete_factor = self.project.obsolete.split("%")[0]
				self.inflation = inflation_factor	
			rescue 
				''
			end
		end
		if final_value.blank?
			begin
				if self.com_type == "A"
					self.final_value = ((self.purchase_unit*(inflation_factor.split("%")[0]))**(((Date.today-self.purchase_date.to_date).to_i)/365.0)*obsolete_factor*diff)/self.exp_life.to_f
				end	
			rescue
				''
			end
		end
	end
end
