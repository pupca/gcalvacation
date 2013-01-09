def get_users
  users = {}
  users["krotilr"] = {:vacation_per_year => {"2012" => 25, "2013" => 25}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 8}}
  users["pozivilovaa"] = {:vacation_per_year => {"2012" => 5, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["lopicics"] = {:vacation_per_year => {"2012" => 5, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["popelakm"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 4}, :extra_work => {"2012" => 1}}
  users["chyliko"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 11.5}}
  users["kratochvilr"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 4}, :extra_work => {"2012" => 0}}
  users["krajcit"] = {:vacation_per_year => {"2012" => 8.5, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["banszelj"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 5}, :extra_work => {"2012" => 0}}
  users["jelinkovas"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 3}, :extra_work => {"2012" => 0}}
  users["imlaufl"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 2}, :extra_work => {"2012" => 0}}
  users["ruzam"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 7}, :extra_work => {"2012" => 0}}
  users["chernikovy"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 2}, :extra_work => {"2012" => 0}}
  users["chernikovae"] = {:vacation_per_year => {"2012" => 4, "2013" => 10}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}} #part-time
  users["strolenyj"] = {:vacation_per_year => {"2012" => 13, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["kiland"] = {:vacation_per_year => {"2012" => 6.5, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["chroustv"] = {:vacation_per_year => {"2012" => 20, "2013" => 20}, :remaining_vacation_from => {"2011" => 1.5}, :extra_work => {"2012" => 0}}
  users["barcakj"] = {:vacation_per_year => {"2012" => 10, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}} #part-time
  users["bilekt"] = {:vacation_per_year => {"2012" => 11, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["baumgartnerm"] = {:vacation_per_year => {"2012" => 8.5, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  users["tobolkar"] = {:vacation_per_year => {"2012" => 10, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}} #konzultovat pocet dovolene, part-time
  users["adamp"] = {:vacation_per_year => {"2012" => 15, "2013" => 20}, :remaining_vacation_from => {"2011" => 0}, :extra_work => {"2012" => 0}}
  return users
end

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