# Сделать хеш, содержащий месяцы и количество дней в месяце. В цикле выводить те месяцы, у которых количество дней ровно 30
require 'date'

def days_in_month(year, month)
    Date.new(year, month, -1).day
end

cur_year = Date.today.year
puts cur_year

calendar = {}
count  = 1

while count <= 12 do
  monthname = Date::MONTHNAMES[count]
  calendar[monthname] =  days_in_month(cur_year, count) 
  count += 1
end

# Выводим месяцы с 30 днями
puts "Месяцы с 30 днями:"
calendar.each do |month, days|
  if days == 30
    puts month
  end
end
