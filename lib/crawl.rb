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
          return document.css("#dvContainer table tbody tr")[1].css("td")[7].text.to_f
        else
          return "N/A"
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
          return document.css(".content table tr")[1].css("td").last.text.to_f
        else
          return "N/A"
        end
      end
    end  
  end
end