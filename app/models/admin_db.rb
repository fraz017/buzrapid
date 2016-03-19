require 'rubyXL'
class AdminDb < ActiveRecord::Base
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
	      data.remain_life = row[12].present? ? row[12].value : ""
	      data.inflation = row[13].present? ? row[13].value : ""
	      data.obsolete = row[14].present? ? row[14].value : ""
	      data.final_value = row[15].present? ? row[15].value.to_f : 0.0    
	      data.project_id = project.id
 				data.save	
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
	end

end
