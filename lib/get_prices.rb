require 'crawl'
class GetPrices
	class << self
		def crawl(project_id,type)
			if type == "admin"
				@records = AdminDb.where(:project_id => project_id)
			else
				@records = ExcelDatum.where(:project_id => project_id)
			end
			@records.each do |record|
				Crawl::Eximpulse.delay(run_at: 15.seconds.from_now).get_price(record.id,type)
				Crawl::Zauba.delay(run_at: 15.seconds.from_now).get_price(record.id,type)
			end
		end
	end
end