require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'mechanize'

input_array = ARGV

@pages_to_scrape = input_array[0].to_i
@interfacelift_url = "https://#{input_array[1].to_s}"
@wallhaven_url = "https://#{input_array[2].to_s}"
#@dir_path = "#{Dir.home}#{input_array[3].to_s}"
@dir_path = "/home/tyler/Pictures/Wallpapers/nature/"
@interfacelift_website = 'http://interfacelift.com'
@wallhaven_website = 'https://wallpapers.wallhaven.cc/wallpapers/
  full/wallhaven-'
@verify_none = OpenSSL::SSL::VERIFY_NONE

def start
  delete_images
  download_interfacelift
  download_wallhaven
end

def delete_images
  d = Dir.new(@dir_path)
  puts @dir_path
  puts d
  d.each do | x |
    xn = File.join(@dir_path, x)
    File.delete(xn) if x != '.' && x != '..'
  end
end

def download_interfacelift
  interfacelift_list = get_image_urls_interfacelift
  interfacelift_list.each do | counter |
    download_image(counter, get_file_name_interfacelift(counter))
  end
end

def get_image_urls_interfacelift
  full_links = Array.new
  (1..@pages_to_scrape).each do | index |
    current_url = "#{@interfacelift_url}/index#{index}.html"
    page = Nokogiri::HTML(open(current_url, {ssl_verify_mode: @verify_none}))
    links = page.css('div.download a')
    links.each do | x |
      full_links.push("#{@interfacelift_website}#{x['href']}")
    end
  end
  full_links
end

def get_file_name_interfacelift(link)
  link[/\d+_[a-zA-Z]+_\d+x\d+.jpg/]
end

def download_image(counter, filename)
  puts "#{@dir_path}#{filename}"
  agent = Mechanize.new
  agent.get(counter).save "#{@dir_path}#{filename}"
end

def download_wallhaven
  wallhaven_list = get_image_urls_wallhaven
  wallhaven_list.each do | counter |
    download_image(counter, get_file_name_wallhaven(counter))
  end
end

def get_image_urls_wallhaven
  wallhaven_full_links = Array.new
  (1..@pages_to_scrape).each do | wallhaven_index |
    wallhaven_current_url = "#{@wallhaven_url}#{wallhaven_index}"
    wallhaven_page = Nokogiri::HTML(open(wallhaven_current_url,
                                         {ssl_verify_mode: @verify_none}))
    wallhaven_links = wallhaven_page.css('a.preview')
    wallhaven_links.each do | x |
      image_id = x['href'][/\d+/]
      wallhaven_individual_page = "https://alpha.wallhaven.cc/wallpaper/
                                   #{image_id}"
      individual_page = Nokogiri::HTML(open(wallhaven_individual_page,
                                            {ssl_verify_mode: @verify_none}))
      individual_links = individual_page.css('img#wallpaper')
      full_link = "https:#{individual_links[0]['src']}"
      puts full_link
      wallhaven_full_links.push(full_link)
    end
  end
  wallhaven_full_links
end

def get_file_name_wallhaven(wallhaven_link)
  if wallhaven_link.include?('.jpg')
    wallhaven_link[/wallhaven-\d+.jpg/]
  else
    wallhaven_link[/wallhaven-\d+.png/]
  end
end

start
