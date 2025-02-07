# Задание - Площадь треугольника

# функция проверки на цифры
def valid_number?(input)
    input.match?(/\A\d+(\.\d+)?\z/) && input.to_f > 0
end

triangleb_input = nil
triangleh_input = nil

puts "Площадь треугольника"

loop do
  puts "Введите основание треугольника (a):"
  triangleb_input = gets.chomp

  break if valid_number?(triangleb_input)
  puts "Некорректное значение. Используйте только положительные числа."
end

loop do
  puts "Введите высоту треугольника (h):"
  triangleh_input = gets.chomp

  break if valid_number?(triangleh_input)
  puts "Некорректное значение. Используйте только положительные числа."
end

puts "Площадь треугольника"

triangleb = triangleb_input.to_f
triangleh = triangleh_input.to_f

triangle_area = 0.5*triangleb*triangleh
puts "Площадь треугольника #{triangle_area}"