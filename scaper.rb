# at present scrapes titles of all datasets listed on homepage of data.dc.gov.  
# much more to come!

require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("http://data.dc.gov"))

columns = [ 'title', 'metadata', 'source', 'text-csv', 'atom', 'kml-esri', 'gmap', 'custom_dl' ]
uid = "title_href_0"

doc.search("table#ctl00_cphMain_mainTable tr").each do |row|
    cells = row.search 'td'
    if cells.count > 0 && cells[0].attr("class") != "minor"
      data = Hash.new

      for i in 0..columns.count-1      
        key = columns[i] + "_txt"
        data[key] = cells[i].text

        for ii in 0..cells[i].xpath("a").count-1
          key = columns[i] + "_href_" + ii.to_s
          data[key] = cells[i].xpath("a")[ii].attr("href")
        end
      end
      
      ScraperWiki.save_sqlite([uid], data)  
    end
end
