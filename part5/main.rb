=begin
    Создать модуль, который позволит указывать название компании-производителя и получать его. Подключить модуль к классам Вагон и Поезд
    В классе Station (жд станция) создать метод класса all, который возвращает все станции (объекты), созданные на данный момент
    Добавить к поезду атрибут Номер (произвольная строка), если его еще нет, который указыватеся при его создании
    В классе Train создать метод класса find, который принимает номер поезда (указанный при его создании) и возвращает объект поезда по номеру или nil, если поезд с таким номером не найден.


    Создать модуль InstanceCounter, содержащий следующие методы класса и инстанс-методы, которые подключаются автоматически при вызове include в классе:
    Методы класса:
           - instances, который возвращает кол-во экземпляров данного класса
    Инстанс-методы:
           - register_instance, который увеличивает счетчик кол-ва экземпляров класса и который можно вызвать из конструктора. При этом данный метод не должен быть публичным.
    Подключить этот модуль в классы поезда, маршрута и станции.
    Примечание: инстансы подклассов могут считаться по отдельности, не увеличивая счетчик инстансов базового класса. 

=end

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'modules'

class Main
  include Menu

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
