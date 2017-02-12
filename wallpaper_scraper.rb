require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'mechanize'

$pages_to_scrape = 2
$interfacelift_url = 'https://interfacelift.com/wallpaper/downloads/date/wide_16:9'
$interfacelift_website = 'http://interfacelift.com'
$wallhaven_url = 'https://alpha.wallhaven.cc/search?q=nature&categories=100&purities=100&resolutions=1920x1080%2C1920x1920%2C2560x1440%2C2560x1600%2C3840x1080%2C5760x1080%2C3840x2160%2C5120x2880&ratios=16x9&sorting=date_added&order=desc&page='
$wallhaven_website = 'https://wallpapers.wallhaven.cc/wallpapers/full/wallhaven-'
$dir_path = '/home/tyler/Pictures/Wallpapers'

def delete_images
  d = Dir.new($dir_path)
  d.each do | x |
    xn = File.join($dir_path, x)
    File.delete(xn) if x != '.' && x != '..'
  end
end

def get_image_urls_interfacelift
  full_links = Array.new
  (1..$pages_to_scrape).each do | index |
    @current_url = "#{$interfacelift_url}/index#{index}.html"
    page = Nokogiri::HTML(open(@current_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
    links = page.css('div.download a')
    links.each do | x |
      full_links.push("#{$interfacelift_website}#{x['href']}")
    end
  end
  full_links
end

def get_image_urls_wallhaven
  wallhaven_full_links = Array.new
  (1..$pages_to_scrape).each do | wallhaven_index |
    @wallhaven_current_url = "#{$wallhaven_url}#{wallhaven_index}"
    wallhaven_page = Nokogiri::HTML(open(@wallhaven_current_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
    wallhaven_links = wallhaven_page.css('a.preview')
    wallhaven_links.each do | x |
      image_id = x['href'][/\d+/]
      wallhaven_individual_page = "https://alpha.wallhaven.cc/wallpaper/#{image_id}"
      individual_page = Nokogiri::HTML(open(wallhaven_individual_page, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
      individual_links = individual_page.css('img#wallpaper')
      full_link = "https:#{individual_links[0]['src']}"
      wallhaven_full_links.push(full_link)
    end
  end
  wallhaven_full_links
end

def get_file_name_interfacelift(link)
  link[/\d+_[a-zA-Z]+_\d+x\d+.jpg/]
end

def get_file_name_wallhaven(wallhaven_link)
  name = if wallhaven_link.include?('.jpg')
           wallhaven_link[/wallhaven-\d+.jpg/]
         else
           wallhaven_link[/wallhaven-\d+.png/]
        end
end

def refresh_images
  delete_images
  interfacelift_list = get_image_urls_interfacelift
  interfacelift_list.each do | counter |
    puts "#{$dir_path}/#{get_file_name_interfacelift(counter)}"
    agent = Mechanize.new
    agent.get(counter).save "#{$dir_path}/#{get_file_name_interfacelift(counter)}"
    #File.open("#{$dir_path}/#{get_file_name_interfacelift(counter)}", 'wb') do | f |
    #  f.write open(counter).read
    #end
  end
  wallhaven_list = get_image_urls_wallhaven
  wallhaven_list.each do | counter |
    puts "#{$dir_path}/#{get_file_name_wallhaven(counter)}"
    agent = Mechanize.new
    agent.get(counter).save "#{$dir_path}/#{get_file_name_wallhaven(counter)}"
    #File.open("#{$dir_path}/#{get_file_name_wallhaven(counter)}", 'wb') do | f |
    #  f.write open(counter).read
    #end
  end
end

refresh_images
