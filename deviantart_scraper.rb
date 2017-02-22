require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'openssl'

$current_offset = 0
$base_url = 'http://arsenixc.deviantart.com/gallery/?offset='
$home_path = "#{Dir.home}/Pictures/Wallpaper"
$running = true

def past_end?
  test_page = Nokogiri::HTML(open("#{$base_url}#{$current_offset}", {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
  more_test = test_page.css('.message')
  if more_test[0] != nil
    slightly_more_test = more_test[0].text
    if slightly_more_test.include?('no deviations')
      puts 'Reached end of pages, terminating...'
      $running = false
    end
  end
end

def goto_next_gallery_page
  $current_offset += 24
end

def get_page_links(url)
  page = Nokogiri::HTML(open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
  page.css("a[class='torpedo-thumb-link']")
end

def get_individual_page(page)
  new_page = Nokogiri::HTML(open(page, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
  new_page.css('.dev-content-full')
end

def get_full_size_link(page)
  page['src']
end

def compact_name(link)
  link[49..-1]
end

def download_image(link)
  agent = Mechanize.new
  agent.get(link).save "#{$home_path}/#{compact_name(link)}"
end

def start
  while $running
    past_end?
    links = get_page_links("#{$base_url}#{$current_offset}")
    links.each do |x|
      page = get_individual_page(x['href'])
      image_link = get_full_size_link(page.first)
      puts "Saving #{compact_name(image_link)}"
      download_image(image_link)
    end
    goto_next_gallery_page
  end
end

start