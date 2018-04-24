require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'json'

args = JSON.parse(open('deviantart.json').read())

@current_offset = 0
@base_url = args['gallery']
@home_path = "#{Dir.home}#{args['dir']}"
@pic_num = 1
@verify_none = OpenSSL::SSL::VERIFY_NONE

def start
  running = true
  while running
    links = get_page_links("#{@base_url}#{@current_offset}")
    iterate_through_pages(links)
    goto_next_gallery_page
    running = past_end?
  end
  puts 'Reached end of pages, terminating...'
end

def get_page_links(url)
  page = Nokogiri::HTML(open(url, ssl_verify_mode: @verify_none))
  page.css("a[class='torpedo-thumb-link']")
end

def iterate_through_pages(page)
  page.each do |x|
    individual_page = get_individual_page(x['href'])
    image_link = get_full_size_link(individual_page.first)
    puts "Saving image ##{@pic_num}: #{compact_name(image_link)}"
    download_image(image_link)
    @pic_num += 1
  end
end

def get_individual_page(page)
  new_page = Nokogiri::HTML(open(page, ssl_verify_mode: @verify_none))
  new_page.css('.dev-content-full')
end

def get_full_size_link(page)
  page['src']
end

def compact_name(link)
  link.split('/')[-1]
end

def download_image(link)
  agent = Mechanize.new
  agent.get(link).save "#{@home_path}/#{compact_name(link)}"
end

def goto_next_gallery_page
  @current_offset += 24
end

def past_end?
  test_page = Nokogiri::HTML(open("#{@base_url}#{@current_offset}",
                                  ssl_verify_mode: @verify_none))
  page_message = test_page.css('.message')
  return true if page_message[0].nil?
  !(page_message[0].text.include?('no deviations'))
end

start