require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'openssl'

search_url = 'https://alpha.wallhaven.cc/search?q=nature&categories=100&purity=100&resolutions=1920x1080%2C1920x1200
%2C2560x1440%2C2560x1600%2C3840x1080%2C5760x1080%2C3840x2160%2C5120x2880&ratios=16x9&sorting=date_added
&order=desc&page='
wallpaper_direct_link = 'https://wallpapers.wallhaven.cc'
wallpaper_page_link = 'https://alpha.wallhaven.cc/wallpaper/'

#page = Nokogiri::HTML(open(search_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
#links = page.css('div.download a')

#links.each do | x |
#	href = x["href"]
#	puts "#{wallpaper_direct_link}#{href}"
#end	

def get_file_name(link)
	#link[/\d+_[a-z]+_\d+x\d+.jpg/]
	link[44..(link.length - 1)]
end

(1..3).each do | index |
	current_url = "#{search_url}#{index}"
	page = Nokogiri::HTML(open(current_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
	links = page.css('a.preview')
	links.each do | x |
		image_id = x['href'][/\d+/]
		current_individual_page = "#{wallpaper_page_link}#{image_id}"
		puts "Link to image page: #{current_individual_page}"
		individual_page = Nokogiri::HTML(open(current_individual_page, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))	
		individual_links  = individual_page.css('img#wallpaper')
		full_link = individual_links[0]['src']
		full_link = "https:#{full_link}"
		puts "Direct Link to image: #{full_link}"

	end	
end