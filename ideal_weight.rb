# Задание - Идеальный вес

# функция проверки на буквы
def valid_name?(name)
  name.match?(/\A[a-zA-Zа-яА-Я]+\z/)
end

# функция проверки на цифры
def valid_height?(height)
  height.match?(/\A\d+\z/) && height.to_i > 0
end

name_input  = nil
height_input = nil

puts "Идеальный вес"

loop do
  puts "Введите ваше имя:"
  name_input  = gets.chomp

  break if valid_name?(name_input )
  puts "Некорректное имя. Используйте только буквы."

end

loop do
  puts "Введите ваш рост в сантиметрах:"
  height_input = gets.chomp

  break if valid_height?(height_input)
  puts "Некорректный рост. Используйте только положительные числа."

end

height = height_input.to_i
ideal_weight = (height - 110) * 1.15

if ideal_weight.positive?
  puts "#{name_input }, ваш идеальный вес: #{ideal_weight.round(2)} кг."
else
  puts "#{name_input }, ваш вес уже оптимальный."
end