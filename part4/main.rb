=begin
    Разбить программу на отдельные классы (каждый класс в отдельном файле)
    Разделить поезда на два типа PassengerTrain и CargoTrain, сделать родителя для классов, который будет содержать общие методы и свойства
    Определить, какие методы могут быть помещены в private/protected и вынести их в такую секцию. В комментарии к методу обосновать, почему он был вынесен в private/protected
    Вагоны теперь делятся на грузовые и пассажирские (отдельные классы). К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые. 
    При добавлении вагона к поезду, объект вагона должен передаваться как аргумент метода и сохраняться во внутреннем массиве поезда, в отличие от предыдущего задания, где мы считали только кол-во вагонов. Параметр конструктора "кол-во вагонов" при этом можно удалить.


Добавить текстовый интерфейс:

Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
     - Создавать станции
     - Создавать поезда
     - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
     - Назначать маршрут поезду
     - Добавлять вагоны к поезду
     - Отцеплять вагоны от поезда
     - Перемещать поезд по маршруту вперед и назад
     - Просматривать список станций и список поездов на станции

=end

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'

stations = []
trains = []
routes = []

loop do
  puts "Выберите действие:"
  puts "1. Создать станцию"
  puts "2. Создать поезд"
  puts "3. Создать маршрут"
  puts "4. Назначить маршрут поезду"
  puts "5. Добавить вагон к поезду"
  puts "6. Отцепить вагон от поезда"
  puts "7. Переместить поезд вперед"
  puts "8. Переместить поезд назад"
  puts "9. Просмотреть список станций и поездов на станциях"
  puts "0. Выйти"

  choice = gets.to_i

  case choice
  when 1
    print "Введите название станции: "
    name = gets.chomp
    stations << Station.new(name)
    puts "Станция '#{name}' создана."

  when 2
    print "Введите номер поезда: "
    number = gets.chomp
    print "Выберите тип (1 - пассажирский, 2 - грузовой): "
    type = gets.to_i
    if type == 1
      trains << PassengerTrain.new(number)
      puts "Создан пассажирский поезд №#{number}."
    else
      trains << CargoTrain.new(number)
      puts "Создан грузовой поезд №#{number}."
    end

  when 3
    if stations.size < 2
      puts "Для создания маршрута нужно минимум 2 станции."
    else
      puts "Выберите начальную и конечную станции:"
      stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
      print "Начальная станция: "
      start = gets.to_i - 1
      print "Конечная станция: "
      finish = gets.to_i - 1
      routes << Route.new(stations[start], stations[finish])
      puts "Маршрут создан."
    end

  when 4
    if trains.empty? || routes.empty?
      puts "Нет поездов или маршрутов!"
    else
      puts "Выберите поезд:"
      trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = trains[gets.to_i - 1]

      puts "Выберите маршрут:"
      routes.each_with_index do |route, index|
        puts "#{index}. #{route.stations.first.name} -> #{route.stations.last.name}"
      end
      route = routes[gets.to_i - 1]

      train.assign_route(route)
      puts "Поезду №#{train.number} назначен маршрут."
    end

  when 5
    if trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = trains[gets.to_i - 1]

      carriage = train.is_a?(PassengerTrain) ? PassengerCarriage.new : CargoCarriage.new
      train.add_carriage(carriage)
      puts "Вагон добавлен к поезду №#{train.number}."
    end

  when 6
    if trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = trains[gets.to_i - 1]

      if train.carriages.empty?
        puts "У поезда нет вагонов!"
      else
        train.remove_carriage(train.carriages.last)
        puts "Вагон отцеплен от поезда №#{train.number}."
      end
    end

  when 7
    if trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = trains[gets.to_i - 1]

      if train.route.nil?
        puts "У поезда нет маршрута!"
      else
        train.move_forward
        puts "Поезд перемещен вперед. Теперь он на станции #{train.current_station.name}."
      end
    end

  when 8
    if trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = trains[gets.to_i - 1]

      if train.route.nil?
        puts "У поезда нет маршрута!"
      else
        train.move_backward
        puts "Поезд перемещен назад. Теперь он на станции #{train.current_station.name}."
      end
    end

  when 9
    stations.each do |station|
      puts "Станция: #{station.name}"
      station.trains.each { |train| puts "  Поезд №#{train.number} (#{train.type})" }
    end

  when 0
    break

  else
    puts "Неверный выбор, попробуйте снова."
  end
end
