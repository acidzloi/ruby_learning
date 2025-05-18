# frozen_string_literal: true

require_relative 'lib/modules'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @stations = []

  class << self
    attr_reader :stations

    def all
      @stations
    end

    def add(station)
      @stations << station
    end
  end

  def initialize(name)
    @name = name.strip
    @trains = []
    validate!
    Station.add(self)
    register_instance
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

  def each_train
    @trains.each(&block) if block
  end

  def list_trains
    if @trains.empty?
      puts 'На станции нет поездов.'
    else
      puts "Список поездов на станции #{@name}:"
      each_train do |train|
        puts "Поезд №#{train.number} (тип: #{train.type})"
        train.list_carriages if train.respond_to?(:list_carriages)
      end
    end
  end

  def validate!
    raise ArgumentError, 'Название станции не может быть пустым' if @name.nil? || @name.empty?
  end
end
