#http://spreadsheet.rubyforge.org/index.html
require 'rubygems'
require 'active_support/all'
require 'awesome_print'
require 'google_calendar'
require 'simple_xlsx'
require './config.rb'

$OFFLINE = false
year = ARGV[3].to_i
users = get_users

def is_public_holiday?(day)
  return true if public_holidays.include?(day)
  return false
end

def not_bussiness_day(day)
  if day.sunday? || day.saturday? || day.year != ARGV[3].to_i || is_public_holiday?(day)
    return true
  else
    return false
  end
end

def full_days(event)
  (Time.parse(event.end_time) - Time.parse(event.start_time)).to_i % (24 * 60 * 60) == 0
end

def id_from_name(name)
  name = name.split(" ")
  return name[1] + name[0][0]
end

def get_events(year)
  if $OFFLINE
    unless File.exist?("save.yaml")
      cal = Google::Calendar.new(:username => ARGV[0], :password => ARGV[1], :app_name => 'gcalvacation', :calendar => ARGV[2])
      File.open("save.yaml", "w+") {|file| file.puts(cal.find_events_in_range(Date.new(year,1,1), Date.new(year+1,1,1),options = {:max_results => 100000}).to_yaml) }
    end
    return File.open("save.yaml", "r") {|file| return YAML.load(file)}
  else  
    cal = Google::Calendar.new(:username => ARGV[0], :password => ARGV[1], :app_name => 'gcalvacation', :calendar => ARGV[2])
    return cal.find_events_in_range(Date.new(year,1,1), Date.new(year+1,1,1),options = {:max_results => 100000})
  end
end

days = {}
out_events = []
events = get_events(year).group_by{|event| event.title.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').downcase.split(" ").collect{|element| element.gsub(/\W+/, '')}[0..1].join(" ")}
events.each do |name, name_events|
  next if users[id_from_name(name)].nil?
  days[name] = Hash.new(0)
  name_events.each do |event|
    total_days = 0
    out_end_time = Date.parse(event.end_time)
    
    if full_days(event)
      out_end_time -= 1
      Date.parse(event.start_time).upto(Date.parse(event.end_time) - 1) do |day|
        next if not_bussiness_day(day)
        days[name][day.month] += 1
        total_days += 1
      end
    else
      time = (Time.parse(event.end_time) - Time.parse(event.start_time)) / (8 * 60 * 60)
      if time > 1
        puts "ERROR - Partial vacation #{event.title} - #{event.start_time} : #{event.end_time} is more than one day"
      else
        days[name][Date.parse(event.start_time).month] += time
        total_days += time
      end
    end
    out_events << {:name => name.split(' ').map {|w| w.capitalize }.join(' '), :from => Date.parse(event.start_time), :to => out_end_time, :total => total_days}
  end
end

File.delete("vacation_#{year}.xlsx") if File.exist?("vacation_#{year}.xlsx")
  
serializer = SimpleXlsx::Serializer.new("vacation_#{year}.xlsx") do |doc|
  doc.add_sheet("Vacation Summary") do |sheet|
    sheet.add_row(["Name", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "Used", "Availible", "Extra Work", "From #{year -1}", "Remaining"])
    Hash[days.sort].each do |key, value|
      row = []
      row << key.split(' ').map {|w| w.capitalize }.join(' ')
      12.times do |i|
        row << value[i+1]
      end
      used = value.inject(0) { |sum, tuple| sum += tuple[1] }
      row << used
      availible = users[id_from_name(key)][:vacation_per_year][year.to_s]
      row << availible
      extra_work = users[id_from_name(key)][:extra_work][year.to_s]
      row << extra_work
      from_last_year = users[id_from_name(key)][:remaining_vacation_from][(year - 1).to_s]
      row << from_last_year
      row << (availible.to_f + from_last_year.to_f + extra_work.to_f) - used.to_f
      sheet.add_row(row)
    end

  end
  
  doc.add_sheet("Vacation List") do |sheet|
    sheet.add_row(%w{Name From To Days})
    out_events.each do |event|
      sheet.add_row([ event[:name], event[:from], event[:to], event[:total]])
    end
  end
end