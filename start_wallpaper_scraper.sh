#!/usr/bin/env bash
# commandline arguments are (in this order):
# num_pages interfacelift_url wallhaven_url directory
# where num_pages is the number of pages for each website to scrape,
# interfacelift_url is the url to the wallpaper search you want to use on
# interfacelift, wallhaven_url is the url to the search that you want to use
# for wallhaven, and directory is the directory in your home folder to save
# files to.
# example:

ruby wallpaper_scraper.rb 2 interfacelift\
.com/wallpaper/downloads/date/wide_16:9 alpha.wallhaven\
.cc/search?q=nature&categories=100&purities=100&resolutions=1920x1080\
%2C1920x1920%2C2560x1440%2C2560x1600%2C3840x1080%2C5760x1080%2C3840x2160\
%2C5120x2880&ratios=16x9&sorting=date_added&order=desc&page= \
/Pictures/Wallpapers