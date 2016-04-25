require 'rubyXL'
require 'crawl'
require 'roo'
class ExcelDatum < ActiveRecord::Base
	belongs_to :project
	before_save :fill_values
	def self.import(project)
		workbook = Roo::Excelx.new("#{project.file.path}")
		# workbook = RubyXL::Parser.parse project.file.path
		# worksheet = workbook[0]
		(workbook.first_row..workbook.last_row).each_with_index do |r, index|
			if index > 0
				row = workbook.row(r)
				data = ExcelDatum.new 	
    		data.com_name = row[0].squish 
	      data.com_type = row[1].squish
	      data.purchase_date = row[2]
	      data.company_type = row[3].squish
	      data.quantity = row[4]
	      data.purchase_unit = row[5].present? ? row[5].to_f : 0.0
	      data.est_price_soft = row[6]
	      data.est_price_pp = row[7]   
	      data.market_value = row[8]   
	      data.exp_life = row[9]
	      data.values_used = row[10]    
	      data.date_purchase = row[11]
	      data.remain_life = row[12].present? ? row[12].squish : ""
	      data.inflation = row[13].present? ? row[13].squish : ""
	      data.obsolete = row[14].present? ? row[14].squish : ""
	      data.final_value = row[15].present? ? row[15].to_f : 0.0    
	      data.project_id = project.id
 				if data.save
 					begin
						Crawl::Zauba.delay(run_at: 10.seconds.from_now, priority: 0).get_price(data.id,"user")
						Crawl::Eximpulse.delay(run_at: 15.seconds.from_now, priority: 1).get_price(data.id,"user")
					rescue
						''
					end
 				end	
			end	
		end
	end
	def self.generate_excel(project_id)
		project = Project.find project_id
		if project.present?
			workbook = RubyXL::Workbook.new
			worksheet = workbook[0]
			records = project.excel_datum
			worksheet.add_cell(0, 0, "Component Name").change_font_bold(true)
			worksheet.add_cell(0, 1, "Component Type").change_font_bold(true)
			worksheet.add_cell(0, 2, "Purchase Date").change_font_bold(true)
			worksheet.add_cell(0, 3, "Industry Type").change_font_bold(true)
			worksheet.add_cell(0, 4, "Qty").change_font_bold(true)
			worksheet.add_cell(0, 5, "Purchase Price").change_font_bold(true)
			worksheet.add_cell(0, 6, "Estimated price from soft volt data A").change_font_bold(true)
			worksheet.add_cell(0, 7, "Estimated price from  Past projects B ").change_font_bold(true)
			worksheet.add_cell(0, 8, "Market value").change_font_bold(true)
			worksheet.add_cell(0, 9, "Expected Life").change_font_bold(true)
			worksheet.add_cell(0, 10, "Values Used").change_font_bold(true)
			worksheet.add_cell(0, 11, "Estimated Date").change_font_bold(true)
			worksheet.add_cell(0, 12, "Remaining Life").change_font_bold(true)
			worksheet.add_cell(0, 13, "Inflation Factor").change_font_bold(true)
			worksheet.add_cell(0, 14, "Obsolete Factor").change_font_bold(true)
			worksheet.add_cell(0, 15, "Final Value").change_font_bold(true)
			worksheet.add_cell(0, 16, "Location").change_font_bold(true)
			worksheet.add_cell(0, 17, "Import/Export").change_font_bold(true)
			worksheet.add_cell(0, 18, "Source").change_font_bold(true)
			worksheet.change_row_horizontal_alignment(0, 'center')
			18.times do |index|
				worksheet.change_column_width(index, 20)
			end
			records.each_with_index do |record, index|
				worksheet.add_cell(index+1, 0, record.com_name.present? ? record.com_name : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 1, record.com_type.present? ? record.com_type : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 2, record.purchase_date.present? ? record.purchase_date : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 3, record.company_type.present? ? record.company_type : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 4, record.quantity.present? ? record.quantity : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 5, record.purchase_unit.present? ? record.purchase_unit : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 6, record.est_price_soft.present? ? record.est_price_soft : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 7, record.est_price_pp.present? ? record.est_price_pp : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 8, record.market_value.present? ? record.market_value : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 9, record.exp_life,present? ? record.exp_life : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 10, record.values_used.present? ? record.values_used : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 11, record.date_purchase.present? ? record.date_purchase : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 12, record.remain_life.present? ? record.remain_life : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 13, record.inflation.present? ? record.inflation : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 14, record.obsolete.present? ? record.obsolete : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 15, record.final_value.present? ? record.final_value : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 16, record.location.present? ? record.location : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 17, record.import_export.present? ? record.import_export : " ").change_horizontal_alignment('center')
				worksheet.add_cell(index+1, 18, record.source.present? ? record.source : " ").change_horizontal_alignment('center')
			end
			file_path = "#{Rails.root}/tmp/exported_data_#{Time.zone.now}.xlsx"
			workbook.write file_path
			return file_path
		end
	end
	private
	def fill_values
		if self.est_price_soft.blank?
			begin
				check = AdminDb.where(:com_name => self.com_name).last
				if check.present?
					self.est_price_soft = check.est_price_soft
				else
					check = ExcelDatum.where(:com_name => self.com_name).last
					if check.present?
						self.est_price_soft = check.est_price_soft
					end
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
					diff = (self.exp_life.to_f-(((Date.today-self.purchase_date.to_date).to_i)/365.0)).round(2)
					self.remain_life = diff
				end	
			rescue 
				''
			end
		end
		if self.inflation.blank?
			begin
				inflation_factor = self.project.inflation
				self.inflation = inflation_factor	
			rescue 
				''
			end
		end
		if self.obsolete.blank?
			begin
				obsolete_factor = self.project.obsolete
				self.obsolete = obsolete_factor
			rescue 
				''
			end
		end
		# if self.market_value.blank?
		# 	begin
		# 		exim_price = Crawl::Eximpulse.get_price(self.com_name)
		# 		if exim_price.present?
		# 			self.market_value = exim_price
		# 		else
		# 			zauba_price = Crawl::Zauba.get_price(self.com_name)
		# 			if zauba_price.present?
		# 				self.market_value = zauba_price
		# 			end
		# 		end
		# 	rescue 
		# 		''
		# 	end
		# end
		# if final_value < 1
		# 	begin
		# 		if self.com_type == "A"
		# 			fvalue = ((self.purchase_unit*(inflation_factor.split("%")[0].to_f))**(((Date.today-self.purchase_date.to_date).to_i)/365.0)*obsolete_factor.split("%")[0].to_f*diff)/self.exp_life.to_f
		# 			self.final_value = fvalue.round(2)
		# 		end
		# 		if self.com_type == "B"
		# 			fvalue = ((self.est_price_soft*(inflation_factor.split("%")[0].to_f))**(((Date.today-self.purchase_date.to_date).to_i)/365.0))*obsolete_factor.split("%")[0].to_f
		# 			self.final_value = fvalue.round(2)
		# 		end
		# 		if self.com_type == "C"
		# 			fvalue = ((self.est_price_pp*(inflation_factor.split("%")[0].to_f))**(((Date.today-self.purchase_date.to_date).to_i)/365.0))*obsolete_factor.split("%")[0].to_f
		# 			self.final_value = fvalue.round(2)
		# 		end	
		# 		if self.com_type == "D"
		# 			self.final_value = self.est_price_pp
		# 		end	
		# 	rescue
		# 		''
		# 	end
		# end
	end
end
