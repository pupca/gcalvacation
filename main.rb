require 'rubygems'
require 'active_support/all'
require 'awesome_print'
require 'google_calendar'
require 'simple_xlsx'

def public_holidays
  holidays = []
  #2012
  holidays << Date.new(2012,1,1)
  holidays << Date.new(2012,4,8)
  holidays << Date.new(2012,4,9)
  holidays << Date.new(2012,5,1)
  holidays << Date.new(2012,5,8)
  holidays << Date.new(2012,7,5)
  holidays << Date.new(2012,7,6)
  holidays << Date.new(2012,9,28)
  holidays << Date.new(2012,10,28)
  holidays << Date.new(2012,11,17)
  holidays << Date.new(2012,12,24)
  holidays << Date.new(2012,12,25)
  holidays << Date.new(2012,12,26)
  #2013
  holidays << Date.new(2013,1,1)
  holidays << Date.new(2013,4,1)
  holidays << Date.new(2013,5,1)
  holidays << Date.new(2013,5,8)
  holidays << Date.new(2013,7,5)
  holidays << Date.new(2013,7,6)
  holidays << Date.new(2013,9,28)
  holidays << Date.new(2013,10,28)
  holidays << Date.new(2013,11,17)
  holidays << Date.new(2013,12,24)
  holidays << Date.new(2013,12,25)
  holidays << Date.new(2013,12,26)
  return holidays
end


$OFFLINE = false
year = ARGV[3].to_i

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

File.delete("result.xlsx") if File.exist?("result.xlsx")
  
serializer = SimpleXlsx::Serializer.new("result.xlsx") do |doc|
  doc.add_sheet("Vacation Summary") do |sheet|
    sheet.add_row(%w{Name January February March April May June July August September October November December Total})
    Hash[days.sort].each do |key, value|
      row = []
      row << key.split(' ').map {|w| w.capitalize }.join(' ')
      12.times do |i|
        row << value[i+1]
      end
      row << value.inject(0) { |sum, tuple| sum += tuple[1] }
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