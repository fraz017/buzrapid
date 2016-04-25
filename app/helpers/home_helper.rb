module HomeHelper
	def username(id)
		user = User.where(:id => id).last
		if user.present?
			return user.name
		else
			return ""
		end
	end
	def final_value_a(id)
		if current_user.role == :admin
			record = AdminDb.where(:id => id).last
		else
			record = ExcelDatum.where(:id => id).last
		end	
		if record.present?
			begin
				diff = (record.exp_life.to_f-(((Date.today-record.purchase_date.to_date).to_i)/365.0)).round(2)
				fvalue = ((record.purchase_unit*(record.inflation.split("%")[0].to_f))**(((Date.today-record.purchase_date.to_date).to_i)/365.0)*record.obsolete.split("%")[0].to_f*diff)/record.exp_life.to_f	
			rescue
				fvalue = 0.0
			end
		else
			fvalue = 0.0	
		end
		return fvalue.nan? ? 0.0 : fvalue.round(2)
	end
	def final_value_b(id)
		if current_user.role == :admin
			record = AdminDb.where(:id => id).last
		else
			record = ExcelDatum.where(:id => id).last
		end	
		if record.present?
			begin
				fvalue = ((record.est_price_soft*(record.inflation.split("%")[0].to_f))**(((Date.today-record.purchase_date.to_date).to_i)/365.0))*record.obsolete.split("%")[0].to_f
			rescue
				fvalue = 0.0
			end
		else
			fvalue = 0.0	
		end
		return fvalue.nan? ? 0.0 : fvalue.round(2)
	end
	def final_value_c(id)
		if current_user.role == :admin
			record = AdminDb.where(:id => id).last
		else
			record = ExcelDatum.where(:id => id).last
		end	
		if record.present?
			begin
				fvalue = ((record.est_price_pp*(record.inflation.split("%")[0].to_f))**(((Date.today-record.purchase_date.to_date).to_i)/365.0))*record.obsolete.split("%")[0].to_f
			rescue
				fvalue = 0.0
			end
		else
			fvalue = 0.0	
		end
		return final_value = fvalue.nan? ? 0.0 : fvalue.round(2)
	end
end
