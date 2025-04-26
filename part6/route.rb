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
    @stations.delete(station) if @stations.include?(station) && @stations.size > 2
  end
  
  def to_s
    station_names = @stations.map(&:name).join(' -> ')
    "Маршрут: #{station_names}"
  end

  def validate!
    raise "Начальная станция не может быть пустой" if @stations.first.nil?
    raise "Конечная станция не может быть пустой" if @stations.last.nil?
    raise "Начальная и конечная станции не могут быть одинаковыми" if @stations.first == @stations.last
  end
end