=begin
Для пассажирских вагонов:

    Добавить атрибут общего кол-ва мест (задается при создании вагона)
    Добавить метод, который "занимает места" в вагоне (по одному за раз)
    Добавить метод, который возвращает кол-во занятых мест в вагоне
    Добавить метод, возвращающий кол-во свободных мест в вагоне.


Для грузовых вагонов:

    Добавить атрибут общего объема (задается при создании вагона)
    Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
    Добавить метод, который возвращает занятый объем
    Добавить метод, который возвращает оставшийся (доступный) объем


У класса Station:

    написать метод, который принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок.


У класса Train:

     написать метод, который принимает блок и проходит по всем вагонам поезда (вагоны должны быть во внутреннем массиве), передавая каждый объект вагона в блок.


Если нет интерфейса, то в отдельном файле, например, main.rb написать код, который:

    Создает тестовые данные (станции, поезда, вагоны) и связывает их между собой.
    Используя созданные в рамках задания методы, написать код, который перебирает последовательно все станции и для каждой станции выводит список поездов в формате:

      - Номер поезда, тип, кол-во вагонов
   А для каждого поезда на станции выводить список вагонов в формате:
      - Номер вагона (можно назначать автоматически), тип вагона, кол-во свободных и занятых мест (для пассажирского вагона) или кол-во свободного и занятого объема (для грузовых вагонов).

Если у вас есть интерфейс, то добавить возможности:

    При создании вагона указывать кол-во мест или общий объем, в зависимости от типа вагона
    Выводить список вагонов у поезда (в указанном выше формате), используя созданные методы
    Выводить список поездов на станции (в указанном выше формате), используя  созданные методы
    Занимать место или объем в вагоне
=end

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'

class Main
  attr_reader :stations, :trains, :routes

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
    { id: 10, title: 'Просмотреть список вагонов у поезда', action: :list_carriages_of_train },
    { id: 11, title: 'Просмотреть список поездов на станции', action: :list_trains_on_station_action },
    { id: 12, title: 'Занять место или объем в вагоне', action: :occupy_seat_or_volume },
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
      choice = take_choice
      handle_action(choice)
    end
  end

  private

  def show_menu
    puts "\nМеню:"
    MENU.each { |item| puts "#{item[:id]}. #{item[:title]}" }
  end

  def take_choice
    loop do
      print "Введите номер действия: "
      input = gets.chomp
  
      begin
        return Integer(input)
      rescue ArgumentError
        puts "Ошибка: нужно ввести целое число. Попробуйте снова."
      end
    end
  end

  def valid_number?(input)
    input.match?(/^\d+$/)
  end

  def handle_action(choice)
    item = MENU.find { |menu_item| menu_item[:id] == choice }
    item ? send(item[:action]) : puts('Некорректный выбор, попробуйте снова.')
  end

  def create_station
    begin
      print "Введите название станции: "
      name = gets.chomp
      station = Station.new(name)
      @stations << station
      puts "Станция '#{station.name}' успешно создана." if station.validate
    rescue => e
      puts "Ошибка: #{e.message}"
    end
  end

  def create_train
    begin
      print "Введите номер поезда (формат: XXX-XX или XXXXX): "
      number = gets.chomp
      print "Выберите тип: 1 — Пассажирский, 2 — Грузовой: "
      type = gets.chomp.to_i 

      train = case type
            when 1 then PassengerTrain.new(number)
            when 2 then CargoTrain.new(number)
            else raise "Некорректный тип поезда"
            end

      @trains << train
      puts "Поезд №#{train.number} успешно создан."
    rescue StandardError => e
      puts "Ошибка: #{e.message}"
    end
  end

  def create_route
    begin
      return puts "Для создания маршрута нужно минимум 2 станции." if @stations.size < 2

      show_stations

      puts "Выберите начальную станцию:"
      start = @stations[gets.to_i - 1]

      puts "Выберите конечную станцию:"
      finish = @stations[gets.to_i - 1]

      @routes << Route.new(start, finish)
      puts "Маршрут успешно создан."
    rescue StandardError => e
      puts "Ошибка: #{e.message}"
      puts "Попробуйте снова.\n\n"
    end
  end

  def show_stations
    @stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
  end

  def assign_route
    begin
      return puts "Нет поездов или маршрутов!" if @trains.empty? || @routes.empty?

      train = select_from(@trains, "Выберите поезд:")
      return unless train
    
      route = select_from(@routes, "Выберите маршрут:")
      return unless route
      
      raise "Поезд не выбран!" unless train
      raise "Маршрут не выбран!" unless route

      train.assign_route(route)
      puts "Поезду №#{train.number} назначен маршрут."
    rescue StandardError => e
      puts "Ошибка: #{e.message}"
    end
  end

  def add_carriage
    return puts "Нет поездов!" if @trains.empty?

    train = select_from(@trains, 'Выберите поезд:')

    if train.is_a?(PassengerTrain)
      print "Введите количество мест в вагоне: "
      seats = gets.to_i
      carriage = PassengerCarriage.new(seats)
    elsif train.is_a?(CargoTrain)
      print "Введите объём вагона: "
      volume = gets.to_f
      carriage = CargoCarriage.new(volume)
    else
      puts "Неизвестный тип поезда."
      return
    end

    if train.add_carriage(carriage)
      puts "Вагон успешно добавлен к поезду №#{train.number}."
    else
      puts "Не удалось добавить вагон. Возможно, поезд находится в движении или тип вагона не совпадает."
    end
  end

  def remove_carriage
    return puts "Нет поездов!" if @trains.empty?

    train = select_from(@trains, 'Выберите поезд:')
    return puts 'У поезда нет вагонов!' if train.carriages.empty?

    carriage = train.carriages.last
    train.remove_carriage(carriage)
    puts "Вагон успешно отцеплен от поезда №#{train.number}."
  end

  def move_train_forward
    move_train(:move_forward, "Поезд перемещён вперёд.")
  end

  def move_train_backward
    move_train(:move_backward, "Поезд перемещён назад.")
  end

  def list_stations_trains
    @stations.each do |station|
      puts "\nСтанция: #{station.name}"
      station.trains.each do |train|
        puts "  Поезд №#{train.number} (#{train.class})"
      end
    end
  end

  def list_carriages_of_train
    return puts "Нет поездов!" if @trains.empty?
  
    train = select_from(@trains, 'Выберите поезд:')  # Выбираем поезд
    return unless train  # Проверяем, что поезд выбран
  
    train.list_carriages  # Выводим список вагонов поезда
  end

  def list_trains_on_station_action
    return puts "Нет станций!" if @stations.empty?
  
    station = select_from(@stations, 'Выберите станцию:')  # Выбираем станцию
    return unless station  # Проверяем, что станция выбрана
  
    station.list_trains  # Выводим список поездов на станции
  end

  def occupy_seat_or_volume
    return puts "Нет поездов!" if @trains.empty?
  
    train = select_from(@trains, 'Выберите поезд:')
    carriage = select_from(train.carriages, 'Выберите вагон:')  # Для простоты выбираем вагон из поезда
  
    if carriage.is_a?(PassengerCarriage)
      carriage.take_seat
      puts "Место занято! Осталось #{carriage.free_seats} свободных мест."
    elsif carriage.is_a?(CargoCarriage)
      print "Введите объем для занять: "
      volume = gets.to_i
      carriage.take_volume(volume)
      puts "Объем занят! Осталось #{carriage.free_volume} свободного объема."
    else
      puts "Некорректный тип вагона."
    end
  end

  def move_train(direction, success_message)
    return puts "Нет поездов!" if @trains.empty?

    train = select_from(@trains, 'Выберите поезд:')
    return puts "У поезда нет маршрута!" unless train.route

    train.send(direction)
    puts "#{success_message} Сейчас он на станции: #{train.current_station.name}."
  end

  def select_from(collection, message)
    return puts "Список пуст!" if collection.empty?
    puts message
    collection.each_with_index do |item, index|
      display_name = if item.is_a?(Train)
                        "Поезд №#{item.number} (#{item.class.to_s})"                    
                    elsif item.is_a?(Station)
                         "Станция: #{item.name}"  # Здесь используем атрибут name станции
                    else
                          item.to_s
                    end

      puts "#{index + 1}. #{display_name}"
    end
    collection[gets.to_i - 1]
  end

  def exit_app
    puts "До свидания!"
    exit
  end
end

Main.new.start