require 'rubygems'
require 'active_support/all'
require 'date'
require 'GCal4Ruby'
require 'awesome_print'
year = 2012
require 'google_calendar'

cal = Google::Calendar.new(:username => ARGV[0],
                           :password => ARGV[1],
                           :app_name => 'gcalvacation',
                           :calendar => ARGV[2])


events = cal.find_events_in_range(Date.new(year,1,1), Date.new(year,12,31),options = {:max_results => 10000})

events.each do |event|
  puts "#{event.title} - #{event.start_time} : #{event.end_time}"
end