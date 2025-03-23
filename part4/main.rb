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
      take_action(get_choice)
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
    item ? send(item[:action]) : puts('Некорректный ввод, попробуйте снова.')
  end

  def create_station
    print "Введите название станции: "
    name = gets.chomp
    return puts 'Название не может быть пустым!' if name.empty?

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
   
    return puts "Для создания маршрута нужно минимум 2 станции." if @stations.size < 2
    
    show_stations
    puts "Выберите начальную и конечную станции:"
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    print "Начальная станция: "
    start = @stations[gets.to_i - 1]
    print "Конечная станция: "
    finish = @stations[gets.to_i - 1]

    @routes << Route.new(start, finish)
    puts "Маршрут создан."
  end

  def assign_route
    return puts "Нет поездов или маршрутов!" if @trains.empty? || @routes.empty?

    train = select_from(@trains, "Выберите поезд:")
    return unless train
  
    route = select_from(@routes, "Выберите маршрут:")
    return unless route


    return puts 'Некорректный ввод!' unless train && route
    
    train.assign_route(route)
    puts "Поезду №#{train.number} назначен маршрут."
  end

  def add_carriage  
    return puts "Нет поездов!" if @trains.empty?

    train = select_from(@trains, 'Выберите поезд')
    train.add_carriage(train.is_a?(PassengerTrain) ? PassengerCarriage.new : CargoCarriage.new)
    puts "Вагон добавлен к поезду №#{train.number}."
  end

  def remove_carriage
    return puts 'Нет поездов!' if @trains.empty?

    train = select_from(@trains, 'Выберите поезд')

    return puts 'У поезда нет вагонов!' if train.carriages.empty?

    train.remove_carriage(train.carriages.last)
    puts "Вагон отцеплен от поезда №#{train.number}."
  end

  def move_train_forward
    move_train(:move_forward, 'Поезд перемещен вперед')
  end

  def move_train_backward
    move_train(:move_backward, 'Поезд перемещен назад')
  end

  def list_stations_trains
    @stations.each do |station|
      puts "Станция: #{station.name}"
      station.trains.each { |train| puts "  Поезд №#{train.number} (#{train.type})" }
    end
  end

  def show_stations
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
  end

  def select_from(collection, message)
    return puts "Список пуст!" if collection.empty?
    puts message
    collection.each_with_index do |item, index|
      display_name = item.is_a?(Train) ? "Поезд №#{item.number} (#{item.class.to_s})" : item.to_s
      puts "#{index + 1}. #{display_name}"
    end
    collection[gets.to_i - 1]
  end

  def move_train(direction, message)
    return puts 'Нет поездов!' if @trains.empty?
    
    train = select_from(@trains, 'Выберите поезд')
    return puts 'У поезда нет маршрута!' unless train.route
    
    train.send(direction)
    puts "#{message}. Теперь он на станции #{train.current_station.name}."
  end

  def exit_app
    puts 'Выход из программы...'
    exit
  end

end

Main.new.start
