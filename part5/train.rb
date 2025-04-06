require_relative 'modules'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :carriages, :route, :current_station_index

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
    if valid_carriage?(carriage)
      @carriages << carriage if @speed.zero?
    else
      puts "Нельзя прицепить этот вагон к данному поезду!"
    end
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

  private

  # Метод проверяет, можно ли добавить вагон к этому поезду (должен быть переопределен в подклассах)
  def valid_carriage?(_carriage)
    false
  end
end