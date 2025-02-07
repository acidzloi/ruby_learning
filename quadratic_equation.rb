# Задание - Квадратное уравнение

def get_coefficient(prompt)
    loop do
      puts prompt
      input = gets.chomp
      coefficient = input.to_i

      # Проверяем, что коэффициент a не равен нулю
      if coefficient == 0
        puts "Коэффициент не может быть равен нулю. Пожалуйста, введите значение снова."
      else
        return coefficient
      end
    end
end

def calculate_roots(a, b, c)
# Вычисление дискриминанта
  d = b**2 - 4*a*c

  # Вывод дискриминанта и корней уравнения
  puts("Дискриминант (D): #{d}")

  if d > 0
      # Два различных корня
      x1 = (-b + Math.sqrt(d)) / (2 * a)
      x2 = (-b - Math.sqrt(d)) / (2 * a)
      puts("Корни уравнения: x1 = #{x1}, x2 = #{x2}")
  elsif d == 0
      # Один корень (двойной корень)
      x = -b / (2 * a)
      puts("Корень уравнения: x = #{x}")
  else
      # Корней нет
      puts("Корней нет")
  end
end

puts "Квадратное уравнение"

# Ввод коэффициентов a, b и c
a = get_coefficient("Введите коэффициент a (не может быть равен нулю):")
b = get_coefficient("Введите коэффициент b:")
c = get_coefficient("Введите коэффициент c:")

# Вычисляем корни уравнения
calculate_roots(a, b, c)