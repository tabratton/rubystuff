require 'rubygems'
require 'nokogiri'
require 'restclient'
require 'open-uri'
require 'fileutils'
require 'mechanize'
require 'rmagick'

@class_name = ARGV[0]
@url_stem = "http://itech.fgcu.edu/faculty/zalewski/#{@class_name}/"

def start
    (1..20).each do |x|
        main_page = "#{@url_stem}#{@class_name}-#{x}.html"
        module_page = Nokogiri::HTML(RestClient.get(main_page))
        activities = module_page.css('li a')
        activities.each do |y|
            if y.text.include? 'viewgraphs'
                link = build_url(y)
                if link.end_with? 'html'
                    handle_html(link, x)
                else
                    handle_ppt(link, x)
                end
            end
        end
    end
end

def build_url(link)
    if link['href'].include? 'lecture'
        url = "#{@url_stem}#{link['href']}"
    else
        url = link['href']
    end
end

def handle_html(link, num)
    directory = "#{Dir.home}/#{@class_name}/module#{num}"
    if !Dir.exist? directory
        FileUtils.mkdir_p directory
    end
    array = Array.new
    viewgraph_page = Nokogiri::HTML(RestClient.get(link))
    links = viewgraph_page.css('li a')
    links.each do |x|
        if x.text.include? 'Foil'
            filename = "#{directory}/#{x.text.strip}.jpg"
            agent = Mechanize.new
            begin
                agent.get("#{@url_stem}lecture#{num}/#{x['href']}").save filename
                array.push filename
            rescue
                puts "broken link i guess"
            end
        end
    end
    begin
        image_list = Magick::ImageList.new(*array)
        image_list.write("#{directory}/foils.pdf")
    rescue
        puts "no images for pdf"
    end
end

def handle_ppt(link, num)
    directory = "#{Dir.home}/#{@class_name}/module#{num}/"
    if !Dir.exist? directory
        FileUtils.mkdir_p directory
    end
    agent = Mechanize.new
    begin
        agent.get(link).save "#{directory}/#{link.split('/')[-1]}"
    rescue
        puts "broken link i guess"
    end
end

start
