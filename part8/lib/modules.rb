# frozen_string_literal: true

module Manufacturer
  attr_accessor :manufacturer
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end

    def increment_instances
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.increment_instances
    end
  end
end

module MenuMethods
  def show_menu(menu)
    puts "\nМеню:"
    menu.each { |item| puts "#{item[:id]}. #{item[:title]}" }
  end

  def take_choice
    loop do
      print 'Введите номер действия: '
      input = gets.chomp
      begin
        return Integer(input)
      rescue ArgumentError
        puts 'Ошибка: нужно ввести целое число. Попробуйте снова.'
      end
    end
  end

  def handle_action(choice, menu)
    loop do
      item = menu.find { |menu_item| menu_item[:id] == choice }
      if item
        send(item[:action])
        break
      else
        puts 'Некорректный выбор, попробуйте снова.'
        choice = take_choice
      end
    end
  end
end

module CreationMethods
  def create_station
    with_handling do
      print 'Введите название станции: '
      name = gets.chomp
      station = Station.new(name)
      station.validate!
      @data_manager.stations << station
      puts "Станция '#{station.name}' успешно создана."
    end
  end

  def create_train
    with_handling do
      print 'Введите номер поезда (формат: XXX-XX или XXXXX): '
      number = gets.chomp
      print 'Выберите тип: 1 — Пассажирский, 2 — Грузовой: '
      type = gets.chomp.to_i

      train = case type
              when 1 then PassengerTrain.new(number)
              when 2 then CargoTrain.new(number)
              else raise 'Некорректный тип поезда'
              end

      @data_manager.trains << train
      puts "Поезд №#{train.number} успешно создан."
    end
  end

  def create_route
    with_handling do
      if @data_manager.stations.size < 2
        puts 'Для создания маршрута нужно минимум 2 станции.'
        return
      end

      start = choose_station('Выберите начальную станцию:')
      finish = choose_station('Выберите конечную станцию:')

      route = Route.new(start, finish)
      @data_manager.routes << route
      puts 'Маршрут успешно создан.'
    end
  end
end

module TrainManagementMethods
  def assign_route
    with_handling do
      if @data_manager.trains.empty? || @data_manager.routes.empty?
        puts 'Нет поездов или маршрутов!'
        return
      end

      train = select_from(@data_manager.trains, 'Выберите поезд:')
      route = select_from(@data_manager.routes, 'Выберите маршрут:')
      return unless train && route

      train.assign_route(route)
      puts "Поезду №#{train.number} назначен маршрут."
    end
  end

  def add_carriage
    return puts 'Нет поездов!' if @data_manager.trains.empty?

    train = select_from(@data_manager.trains, 'Выберите поезд:')
    carriage = build_carriage_for(train)
    return unless carriage

    if train.add_carriage(carriage)
      puts "Вагон успешно добавлен к поезду №#{train.number}."
    else
      puts 'Не удалось добавить вагон. Возможно, поезд находится в движении или тип вагона не совпадает.'
    end
  end

  def build_carriage_for(train)
    if train.is_a?(PassengerTrain)
      print 'Введите количество мест в вагоне: '
      PassengerCarriage.new(gets.to_i)
    elsif train.is_a?(CargoTrain)
      print 'Введите объём вагона: '
      CargoCarriage.new(gets.to_f)
    else
      puts 'Неизвестный тип поезда.'
      nil
    end
  end

  def remove_carriage
    return puts 'Нет поездов!' if @data_manager.trains.empty?

    train = select_from(@data_manager.trains, 'Выберите поезд:')
    return puts 'У поезда нет вагонов!' if train.carriages.empty?

    carriage = train.carriages.last
    train.remove_carriage(carriage)
    puts "Вагон успешно отцеплен от поезда №#{train.number}."
  end

  def move_train_forward
    move_train(:move_forward, 'Поезд перемещён вперёд.')
  end

  def move_train_backward
    move_train(:move_backward, 'Поезд перемещён назад.')
  end

  def move_train(direction, success_message)
    return puts 'Нет поездов!' if @data_manager.trains.empty?

    train = select_from(@data_manager.trains, 'Выберите поезд:')
    return puts 'У поезда нет маршрута!' unless train.route

    train.send(direction)
    puts "#{success_message} Сейчас он на станции: #{train.current_station.name}."
  end
end

module DisplayMethods
  def list_stations_trains
    @data_manager.stations.each do |station|
      puts "\nСтанция: #{station.name}"
      station.trains.each do |train|
        puts "  Поезд №#{train.number} (#{train.class})"
      end
    end
  end

  def list_carriages_of_train
    return puts 'Нет поездов!' if @data_manager.trains.empty?

    train = select_from(@data_manager.trains, 'Выберите поезд:')
    return unless train

    train.list_carriages
  end

  def list_trains_on_station_action
    return puts 'Нет станций!' if @data_manager.stations.empty?

    station = select_from(@data_manager.stations, 'Выберите станцию:')
    return unless station

    station.list_trains
  end
end

module OccupyMethods
  def occupy_seat_or_volume
    return puts 'Нет поездов!' if @data_manager.trains.empty?

    train = select_from(@data_manager.trains, 'Выберите поезд:')
    return unless train
    return puts 'У поезда нет вагонов!' if train.carriages.empty?

    carriage = select_from(train.carriages, 'Выберите вагон:')
    return unless carriage

    occupy_place(carriage)
  end

  def occupy_place(carriage)
    if carriage.is_a?(PassengerCarriage)
      carriage.take_seat
      puts "Место занято! Осталось #{carriage.free_place} свободных мест."
    elsif carriage.is_a?(CargoCarriage)
      print 'Введите объем который хотите занять: '
      volume = gets.to_i
      carriage.take_place(volume)
      puts "Объем занят! Осталось #{carriage.free_place} свободного объема."
    else
      puts 'Некорректный тип вагона.'
    end
  end
end

module HelperMethods
  def with_handling
    yield
  rescue StandardError => e
    puts "Ошибка: #{e.message}"
  end

  def select_from(collection, message)
    return puts('Список пуст!') && nil if collection.empty?

    puts message
    print_collection(collection)
    collection[gets.to_i - 1]
  end

  def print_collection(collection)
    collection.each_with_index do |item, index|
      display_name = case item
                     when Train
                       "Поезд №#{item.number} (#{item.class})"
                     when Station
                       "Станция: #{item.name}"
                     else
                       item.to_s
                     end
      puts "#{index + 1}. #{display_name}"
    end
  end

  def choose_station(prompt)
    puts 'Список станций:'
    @data_manager.stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    print "#{prompt} "
    @data_manager.stations[gets.to_i - 1]
  end

  def exit_app
    puts 'До свидания!'
    exit
  end
end
