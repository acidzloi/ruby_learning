require_relative 'lib/modules'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  # Переменная класса для хранения всех станций
  @@stations = []

  class << self
    attr_reader :stations

    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    @trains = []

    validate
    register_instance
    @@stations << self
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def list_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def validate
    raise if @name.strip.empty?
  end

  def each_train
    @trains.each { |train| yield(train) } if block_given?
  end

  def list_trains
    if @trains.empty?
      puts "На станции нет поездов."
    else
      puts "Список поездов на станции #{@name}:"
      @trains.each do |train|
        puts "Поезд №#{train.number} (тип: #{train.type})"
        train.list_carriages  # Выводим список вагонов поезда
      end
    end
  end

end