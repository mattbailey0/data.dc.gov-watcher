# at present scrapes titles of all datasets listed on homepage of data.dc.gov.  
# much more to come!

require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(open("http://data.dc.gov"))
ScraperWiki::sqliteexecute("drop table if exists swdata")

doc.search("table#ctl00_cphMain_mainTable tr").each do |row|
    cells = row.search 'td'
    if cells.count > 0 && cells[0].attr("class") != "minor"
      data = {
        'title' => cells[0].text
        }
      ScraperWiki.save_sqlite(['title'], data)  
    end
end
