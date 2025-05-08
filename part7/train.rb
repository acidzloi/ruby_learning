require_relative 'lib/modules'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :carriages, :route, :current_station_index

  TRAIN_NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    @route = nil
    @current_station_index = nil

    validate!
    @@trains[number] = self
    register_instance
  end

  def accelerate(increment)
    @speed += increment
  end

  def brake
    @speed = 0
  end

  def add_carriage(carriage)
    return false unless valid_carriage?(carriage)
    return false unless @speed.zero?
  
    @carriages << carriage
    true
  end

  def remove_carriage(carriage)
    @carriages.delete(carriage) if @speed.zero?
  end

  def assign_route(route)
    @route = route
    @current_station_index = 0
    current_station.accept_train(self)
  end

  def move_forward
    return unless next_station

    current_station.send_train(self)
    @current_station_index += 1
    current_station.accept_train(self)
  end

  def move_backward
    return unless previous_station

    current_station.send_train(self)
    @current_station_index -= 1
    current_station.accept_train(self)
  end

  def current_station
    @route.stations[@current_station_index] if @route
  end

  def previous_station
    @route.stations[@current_station_index - 1] if @route && @current_station_index.positive?
  end

  def next_station
    @route.stations[@current_station_index + 1] if @route && @current_station_index < @route.stations.size - 1
  end

  def valid?
    validate!
    true
  rescue ValidationError
    false
  end

  def each_carriage
    @carriages.each { |carriage| yield(carriage) } if block_given?
  end


  # Метод для добавления вагона
  def add_carriage(carriage)
    @carriages << carriage
  end

  # Метод для вывода списка вагонов
  def list_carriages
    puts "Список вагонов поезда #{@number}:"
    @carriages.each_with_index do |carriage, index|
      if carriage.is_a?(PassengerCarriage)
        puts "#{index + 1}. Пассажирский вагон, мест: #{carriage.total_place}, занятых: #{carriage.used_place}"
      elsif carriage.is_a?(CargoCarriage)
        puts "#{index + 1}. Грузовой вагон, объём: #{carriage.total_place}, занято: #{carriage.used_place}"
      end
    end
  end

  private

  # Метод проверяет, можно ли добавить вагон к этому поезду (должен быть переопределен в подклассах)
  def valid_carriage?(_carriage)
    false
  end

  def validate!
    raise "Номер не может быть пустым!" if number.nil? || number.strip.empty?
    raise "Неверный формат номера!" if number !~ TRAIN_NUMBER_FORMAT
  end

end