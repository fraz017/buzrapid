require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'uri'
module Crawl
  class Eximpulse
    class << self
      def get_price(product)
        baseUrl = "https://www.eximpulse.com/import-product-#{product.gsub(' ','-')}.htm"
        document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        if document.css("#dvContainer table tbody tr").count > 2
          document.css("#dvContainer table tbody tr").each_with_index do |tr, index|
            if index == 0
              next
            end
            hs_code = tr.css("td")[2].text
            description = tr.css("td")[4].text
            origin = tr.css("td")[3].text
            per_unit = tr.css("td")[7].text.to_f
            source = "www.eximpulse.com"
            # Save the record and excel row id
          end
          return
        else
          newproduct = product.split(' ')[0...-1].join(' ')
          while(newproduct != "")
            baseUrl = "https://www.eximpulse.com/import-product-#{newproduct.gsub(' ','-')}.htm"
            document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
            if document.css("#dvContainer table tbody tr").count > 2
              document.css("#dvContainer table tbody tr").each_with_index do |tr, index|
                if index == 0
                  next
                end
                hs_code = tr.css("td")[2].text
                description = tr.css("td")[4].text
                origin = tr.css("td")[3].text
                per_unit = tr.css("td")[7].text.to_f
                source = "www.eximpulse.com"
                # Save the record and excel row id
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
      def get_price(product)
        baseUrl = "https://www.zauba.com/import-#{product.downcase.gsub(' ', '-')}-hs-code.html"
        document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
        if document.css(".content table tr").count > 0
          document.css(".content table tr").each_with_index do |tr, index|
            if index == 0
              next
            end
            hs_code = tr.css("td")[1].text
            description = tr.css("td")[2].text
            origin = tr.css("td")[3].text
            per_unit = tr.css("td")[8].text.to_f
            source = "www.zauba.com"
            # Save the record and excel row id
          end
          return
        else
          newproduct = product.split(' ')[0...-1].join(' ')
          while(newproduct != "")
            baseUrl = "https://www.zauba.com/import-#{newproduct.downcase.gsub(' ', '-')}-hs-code.html"
            document = Nokogiri::HTML(open(baseUrl, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
            if document.css(".content table tr").count > 0
              document.css(".content table tr").each_with_index do |tr|
                if index == 0
                  next
                end
                hs_code = tr.css("td")[1].text
                description = tr.css("td")[2].text
                origin = tr.css("td")[3].text
                per_unit = tr.css("td")[8].text.to_f
                # Save the record and excel row id
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