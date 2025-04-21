=begin
    Реализовать проверку (валидацию) данных для всех классов. Проверять основные атрибуты (название, номер, тип и т.п.) на наличие, длину и т.п. (в зависимости от атрибута):

      - Валидация должна вызываться при создании объекта, если объект невалидный, то должно выбрасываться исключение
      - Должен быть метод valid? который возвращает true, если объект валидный и false - в противном случае.

    Релизовать проверку на формат номера поезда. Допустимый формат: три буквы или цифры в любом порядке, необязательный дефис (может быть, а может нет) и еще 2 буквы или цифры после дефиса.
    Убрать из классов все puts (кроме методов, которые и должны что-то выводить на экран), методы просто возвращают значения. (Начинаем бороться за чистоту кода).
    Релизовать простой текстовый интерфейс для создания поездов (если у вас уже реализован интерфейс, то дополнить его):

    - Программа запрашивает у пользователя данные для создания поезда (номер и другие необходимые атрибуты)
    - Если атрибуты валидные, то выводим информацию о том, что создан такой-то поезд
     - Если введенные данные невалидные, то программа должна вывести сообщение о возникших ошибках и заново запросить данные у пользователя. Реализовать это через механизм обработки исключений
=end

require_relative 'lib/menu'
require_relative 'lib/main'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'

app = Main.new

loop do
  puts "\nМеню:"
  puts Menu.show_menu
  print "\nВыберите действие: "

  input = gets.chomp
  if input.strip.empty?
    puts "Вы ничего не ввели. Попробуйте снова!"
    next
  end

  choice = input.to_i
  action = Menu.find_action(choice)

  case action
  when :create_station
    loop do
      begin
        print "Введите название станции: "
        name = gets.chomp
        raise "Название не может быть пустым!" if name.strip.empty?

        result = app.create_station(name)
        puts result == true ? "Станция '#{name}' создана." : result
        break
      rescue RuntimeError => e
        puts "Ошибка: #{e.message}"
      end
    end

  when :create_train
    loop do
      begin
        print "Введите номер поезда (формат: XXX-XX или XXXXX): "
        number = gets.chomp

        print "Тип поезда (1 - пассажирский, 2 - грузовой): "
        type = gets.to_i

        result = app.create_train(number, type)

        if result == :passenger
          puts "Создан пассажирский поезд №#{number}."
          break
        elsif result == :cargo
          puts "Создан грузовой поезд №#{number}."
          break
        else
          puts "Ошибка: #{result}"
        end
    
    rescue ArgumentError
      puts "Ошибка: тип поезда должен быть числом: 1 или 2."
    rescue RuntimeError => e
      puts "Ошибка: #{e.message}"
    end
  end  

  when :create_route
    if app.stations.size < 2
      puts 'Создайте хотя бы 2 станции.'
      next
    end

    app.stations.each_with_index { |s, i| puts "#{i}: #{s.name}" }
    print "Начальная станция индекс: "
    start_index = gets.to_i
    print "Конечная станция индекс: "
    end_index = gets.to_i

    result = app.create_route(start_index, end_index)
    puts result == true ? "Маршрут создан." : result

  when :assign_route
    loop do
      begin
        if app.trains.empty? || app.routes.empty?
          puts 'Нет доступных поездов или маршрутов!'
          break
        end

        puts "\nДоступные поезда:"
        app.trains.each_with_index { |t, i| puts "#{i}: Поезд №#{t.number}" }
        print "Выберите поезд по индексу: "
        train_index_input = gets.chomp
        raise "Индекс поезда не может быть пустым." if train_index_input.strip.empty?
        train_index = Integer(train_index_input)

        puts "\nДоступные маршруты:"
        app.routes.each_with_index { |r, i| puts "#{i}: Маршрут #{r}" }
        print "Выберите маршрут по индексу: "
        route_index_input = gets.chomp
        raise "Индекс маршрута не может быть пустым." if route_index_input.strip.empty?
        route_index = Integer(route_index_input)

        result = app.assign_route(train_index, route_index)
        puts result == true ? "Маршрут назначен поезду." : result
        break
      rescue ArgumentError
        puts "Индекс должен быть числом."
      rescue RuntimeError => e
        puts "Ошибка: #{e.message}"
      end
    end

  when :add_carriage
    loop do
      begin
        if app.trains.empty?
          puts "Нет поездов для добавления вагона."
          break
        end

        app.trains.each_with_index { |t, i| puts "#{i}: Поезд №#{t.number}" }
        print "Выберите поезд по индексу: "
        train_index = gets.to_i

        result = app.add_carriage(train_index)
        puts result == true ? "Вагон добавлен." : result
        break
      rescue RuntimeError => e
        puts "Ошибка: #{e.message}"
      end
    end

  when :remove_carriage
    loop do
      begin
        if app.trains.empty?
          puts "Нет поездов для удаления вагона."
          break
        end

        app.trains.each_with_index { |t, i| puts "#{i}: Поезд №#{t.number}" }
        print "Выберите поезд по индексу: "
        train_index = gets.to_i

        result = app.remove_carriage(train_index)
        puts result == true ? "Вагон отцеплен." : result
        break
      rescue RuntimeError => e
        puts "Ошибка: #{e.message}"
      end
    end

  when :move_train_forward
    loop do
      begin
        if app.trains.empty?
          puts "Нет поездов для перемещения."
          break
        end

        app.trains.each_with_index { |t, i| puts "#{i}: Поезд №#{t.number}" }
        print "Выберите поезд по индексу: "
        train_index = gets.to_i

        result = app.move_train_forward(train_index)
        if result.is_a?(String)
          puts "Поезд перемещен на станцию: #{result}"
          break
        else
          puts "#{result}"
        end
      rescue RuntimeError => e
        puts "Ошибка: #{e.message}"
      end
    end


  when :move_train_backward
    loop do
      begin
        if app.trains.empty?
          puts "Нет поездов для перемещения."
          break
        end

        app.trains.each_with_index { |t, i| puts "#{i}: Поезд №#{t.number}" }
        print "Выберите поезд по индексу: "
        train_index = gets.to_i

        result = app.move_train_backward(train_index)
        if result.is_a?(String)
          puts "Поезд перемещен на станцию: #{result}"
          break
        else
          puts "#{result}"
        end
      rescue RuntimeError => e
        puts "Ошибка: #{e.message}"
      end
    end

  when :list_stations_trains
    begin
      stations = app.list_stations_trains
      if stations.empty?
        puts "Список станций пуст."
      else
        stations.each do |station_info|
          puts "Станция: #{station_info[:station]}"
          station_info[:trains].each do |train|
            puts "  Поезд №#{train[:number]} (#{train[:type]})"
          end
        end
      end
    rescue RuntimeError => e
      puts "Ошибка при выводе станций: #{e.message}"
    end

  when :exit_app
    puts 'Выход из программы...'
    exit

  else
    puts 'Некорректный ввод, попробуйте снова.'
  end
end
