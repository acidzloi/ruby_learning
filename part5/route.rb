require_relative 'modules'

class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]

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
end