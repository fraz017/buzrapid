require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'uri'
module Crawl
  class Eximpulse
    class << self
      def get_price(product_id,type)
        if type == "admin"
          product = AdminDb.where(:id => product_id).last
        else
          product = ExcelDatum.where(:id => product_id).last
        end
        begin
          baseUrl = "https://www.eximpulse.com/import-product-#{product.com_name.gsub(' ','-')}.htm"
          document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        rescue
          return
        end
        if document.css("#dvContainer table tbody tr").count > 2
          document.css("#dvContainer table tbody tr").each_with_index do |tr, index|
            if index == 0
              next
            end
            begin
            record = ScrapRecord.new
            record.hs_code = tr.css("td")[2].try(:text)
            record.desc = tr.css("td")[4].try(:text)
            record.country = tr.css("td")[3].try(:text)
            record.price_pp = tr.css("td")[7].try(:text).to_f
            record.source = "www.eximpulse.com"
            if type == "admin"
              record.admin_db_id = product.id
            else
              record.excel_datum_id = product.id
            end
            record.save!
            rescue
            end
          end
          
          return
        else
          newproduct = product.com_name.split(' ')[0...-1].join(' ')
          while(newproduct != "")
            begin
              baseUrl = "https://www.eximpulse.com/import-product-#{newproduct.gsub(' ','-')}.htm"
              document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
            rescue
              return
            end
            if document.css("#dvContainer table tbody tr").count > 2
              document.css("#dvContainer table tbody tr").each_with_index do |tr, index|
                if index == 0
                  next
                end
                begin
                record = ScrapRecord.new
                record.hs_code = tr.css("td")[2].try(:text)
                record.desc = tr.css("td")[4].try(:text)
                record.country = tr.css("td")[3].try(:text)
                record.price_pp = tr.css("td")[7].try(:text).to_f
                record.source = "www.eximpulse.com"
                if type == "admin"
                  record.admin_db_id = product.id
                else
                  record.excel_datum_id = product.id
                end
                record.save!
                rescue
                end
              end
              
              return
            end
            newproduct = newproduct.split(' ')[0...-1].join(' ')
          end
          return
        end
      end
    end  
  end

  class Zauba
    class << self
      def get_price(product_id,type)
        if type == "admin"
          product = AdminDb.where(:id => product_id).last
        else
          product = ExcelDatum.where(:id => product_id).last
        end
        begin
          baseUrl = "https://www.zauba.com/import-#{product.com_name.downcase.gsub(' ', '-')}-hs-code.html"
          document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        rescue
          return
        end
        if document.css(".content table tr").count > 0
          document.css(".content table tr").each_with_index do |tr, index|
            if index == 0
              next
            end
            begin
            record = ScrapRecord.new
            record.hs_code = tr.css("td")[2].try(:text)
            record.desc = tr.css("td")[4].try(:text)
            record.country = tr.css("td")[3].try(:text)
            record.price_pp = tr.css("td")[7].try(:text).to_f
            record.source = "www.zauba.com"
            if type == "admin"
              record.admin_db_id = product.id
            else
              record.excel_datum_id = product.id
            end
            record.save!
            rescue
            end
          end
          
          return
        else
          newproduct = product.com_name.split(' ')[0...-1].join(' ')
          while(newproduct != "")
            begin
              baseUrl = "https://www.zauba.com/import-#{newproduct.downcase.gsub(' ', '-')}-hs-code.html"
              document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
            rescue
              return
            end
            if document.css(".content table tr").count > 0
              document.css(".content table tr").each_with_index do |tr|
                if index == 0
                  next
                end
                begin
                record = ScrapRecord.new
                record.hs_code = tr.css("td")[2].try(:text)
                record.desc = tr.css("td")[4].try(:text)
                record.country = tr.css("td")[3].try(:text)
                record.price_pp = tr.css("td")[7].try(:text).to_f
                record.source = "www.zauba.com"
                if type == "admin"
                  record.admin_db_id = product.id
                else
                  record.excel_datum_id = product.id
                end
                record.save!
                rescue
                end
              end
              
              return
            end
            newproduct = newproduct.split(' ')[0...-1].join(' ')
          end
          return 
        end
      end
    end  
  end
end