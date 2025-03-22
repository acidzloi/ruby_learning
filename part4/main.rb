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


class Main
  MENU = [
          { id: 1, title: 'Создать станцию', action: :create_station },
          { id: 2, title: 'Создать поезд', action: :create_train },
          { id: 3, title: 'Создать маршрут', action: :create_route }, 
          { id: 4, title: 'Назначить маршрут поезду', action: :assign_route }, 
          { id: 5, title: 'Добавить вагон к поезду', action: :add_carriage }, 
          { id: 6, title: 'Отцепить вагон от поезда', action: :remove_carriage }, 
          { id: 7, title: 'Переместить поезд вперед', action: :move_train_forward }, 
          { id: 8, title: 'Переместить поезд назад', action: :move_train_backward }, 
          { id: 9, title: 'Просмотреть список станций и поездов на станциях', action: :list_stations_trains }, 
          { id: 0, title: 'Выйти', action: :exit_app } 
        ]

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end
  
  def start
    loop do
      show_menu
      choice = get_choice
      take_action(choice)
    end
  end

  def show_menu
    MENU.each{ |item| puts "#{item[:id]}. #{item[:title]}" }
  end

  def get_choice
    puts 'Выберите действие: '
    gets.chomp.to_i
  end

  def take_action (choice)
    item = MENU.find { |menu_item| menu_item[:id] == choice }
    if item
      send(item[:action])
    else
      puts 'Некорректный ввод, попробуйте снова.'
    end
  end

  def create_station
    print "Введите название станции: "
    name = gets.chomp
    @stations << Station.new(name)
    puts "Станция '#{name}' создана."
  end

  def create_train
    print "Введите номер поезда: "
    number = gets.chomp
    print "Выберите тип (1 - пассажирский, 2 - грузовой): "
    type = gets.to_i

    if type == 1
      @trains << PassengerTrain.new(number)
      puts "Создан пассажирский поезд №#{number}."
    elsif type == 2
      @trains << CargoTrain.new(number)
      puts "Создан грузовой поезд №#{number}."
    else
      puts 'Некорректный тип поезда.'
    end
  end

  def create_route
    if @stations.size < 2
      puts "Для создания маршрута нужно минимум 2 станции."
    else
      puts "Выберите начальную и конечную станции:"
      @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
      print "Начальная станция: "
      start = gets.to_i - 1
      print "Конечная станция: "
      finish = gets.to_i - 1
      @routes << Route.new(@stations[start], @stations[finish])
      puts "Маршрут создан."
    end
  end

  def assign_route
    if @trains.empty? || @routes.empty?
      puts "Нет поездов или маршрутов!"
    else
      puts "Выберите поезд:"
      @trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = @trains[gets.to_i - 1]

      puts "Выберите маршрут:"
      @routes.each_with_index do |route, index|
      puts "#{index}. #{route.stations.first.name} -> #{route.stations.last.name}"
    end
      route = @routes[gets.to_i - 1]

      train.assign_route(route)
      puts "Поезду №#{train.number} назначен маршрут."
    end
  end

  def add_carriage
    if @trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      @trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = @trains[gets.to_i - 1]

      carriage = train.is_a?(PassengerTrain) ? PassengerCarriage.new : CargoCarriage.new
      train.add_carriage(carriage)
      puts "Вагон добавлен к поезду №#{train.number}."
    end
  end

  def remove_carriage
    if @trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      @trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = @trains[gets.to_i - 1]

      if train.carriages.empty?
        puts "У поезда нет вагонов!"
      else
        train.remove_carriage(train.carriages.last)
        puts "Вагон отцеплен от поезда №#{train.number}."
      end
    end
  end

  def move_train_forward
    if @trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      @trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = @trains[gets.to_i - 1]
  
      if train.route.nil?
        puts "У поезда нет маршрута!"
      else
        train.move_forward
        puts "Поезд перемещен вперед. Теперь он на станции #{train.current_station.name}."
      end
    end
  end

  def move_train_backward
    if @trains.empty?
      puts "Нет поездов!"
    else
      puts "Выберите поезд:"
      @trains.each_with_index { |train, index| puts "#{index + 1}. Поезд №#{train.number} (#{train.type})" }
      train = @trains[gets.to_i - 1]
  
      if train.route.nil?
        puts "У поезда нет маршрута!"
      else
        train.move_backward
        puts "Поезд перемещен назад. Теперь он на станции #{train.current_station.name}."
      end
    end
  end

  def list_stations_trains
    @stations.each do |station|
      puts "Станция: #{station.name}"
      station.trains.each { |train| puts "  Поезд №#{train.number} (#{train.type})" }
    end
  end

  def exit_app
    puts 'Выход из программы...'
    exit
  end

end

Main.new.start
