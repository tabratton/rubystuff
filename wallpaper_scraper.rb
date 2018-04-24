require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'mechanize'
require 'json'

args = JSON.parse(open('wallpaper.json').read())

@pages_to_scrape = args['pages']
@interfacelift_url = args['interfacelift']
@wallhaven_url = args['wallhaven']
@dir_path = "#{Dir.home}#{args['dir']}"
@verify_none = OpenSSL::SSL::VERIFY_NONE

def start
  delete_images
  download_interfacelift
  download_wallhaven
end

def delete_images
  d = Dir.new(@dir_path)
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
      full_links.push("http://interfacelift.com#{x['href']}")
    end
  end
  full_links
end

def get_file_name_interfacelift(link)
  link[/\d+_[a-zA-Z]+_\d+x\d+.jpg/]
end

def download_image(counter, filename)
  puts "#{@dir_path}/#{filename}"
  agent = Mechanize.new
  agent.get(counter).save "#{@dir_path}/#{filename}"
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
