# frozen_string_literal: true

require_relative 'lib/modules'

class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]

    validate!
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    return unless intermediate_stations.include?(station)

    @stations.delete(station)
  end

  def intermediate_stations
    @stations[1...-1]
  end

  def to_s
    station_names = @stations.map(&:name).join(' -> ')
    "Маршрут: #{station_names}"
  end

  def validate!
    raise ArgumentError, 'Начальная станция не может быть пустой' if @stations.first.nil?
    raise ArgumentError, 'Конечная станция не может быть пустой' if @stations.last.nil?
    raise ArgumentError, 'Начальная и конечная станции не могут быть одинаковыми' if @stations.first == @stations.last
  end
end
