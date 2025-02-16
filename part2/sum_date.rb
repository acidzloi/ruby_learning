# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя). Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.

# Проверка на високосный год
def leap_year?(year)
    (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
end

def day_of_year(day, month, year)
  # Массив с количеством дней в каждом месяце
  days_in_month = [31, leap_year?(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  
  # Вычисление порядкового номера даты
  ordinal_day = 0
  (1...month).each do |m|
    ordinal_day += days_in_month[m - 1]
  end
  ordinal_day += day

  ordinal_day
end

puts "Введите день:"
day_input  = gets.chomp.to_i

puts "Введите месяц:"
month_input  = gets.chomp.to_i

puts "Введите год:"
year_input  = gets.chomp.to_i

# Вычисляем и выводим порядковый номер даты
result = day_of_year(day_input, month_input, year_input)

puts "Порядковый номер даты: #{result}" 