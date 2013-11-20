# at present scrapes titles of all datasets listed on homepage of data.dc.gov.  
# much more to come!

require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("http://data.dc.gov"))
#ScraperWiki::sqliteexecute("drop table if exists swdata")

doc.search("table#ctl00_cphMain_mainTable tr").each do |row|
    cells = row.search 'td'
    if cells.count > 0 && cells[0].attr("class") != "minor"
      data = {
        'title' => cells[0].text,
        'metadata_href' => cells[0].xpath("a").attr("href"),
        'source' => cells[1].text,
        'source_href' => cells[1].xpath("a").attr("href")
        
        #'text_csv_href' => cells[3].xpath("a").attr("href"),
        #'atom_href' => cells[4].xpath("a").attr("href"),
        #'kml_esri_href' => cells[5].xpath("a").attr("href"),
        #'gmap_href' => cells[6].xpath("a").attr("href"),
        #'cust_download_href' => cells[7].xpath("a").attr("href")
        }
      if cells[2].xpath("a")[0] 
        data['xml_href'] = cells[2].xpath("a")[0].attr("href")
      end
      ScraperWiki.save_sqlite(['title'], data)  
    end
end
