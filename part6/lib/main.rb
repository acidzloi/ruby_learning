require_relative 'menu'

class Main
    attr_reader :stations, :trains, :routes
  
    def initialize
      @stations = []
      @trains = []
      @routes = []
    end
  
    def create_station(name)
      return 'Название не может быть пустым!' if name.strip.empty?
      @stations << Station.new(name)
      true
    end
  
    def create_train(number, type)
      return 'Неверный формат номера поезда!' unless number =~ /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i
      case type
      when 1
        @trains << PassengerTrain.new(number)
        :passenger
      when 2
        @trains << CargoTrain.new(number)
        :cargo
      else
        'Некорректный тип поезда!'
      end
    end
  
    def create_route(start_index, end_index)
      return 'Нужно минимум 2 станции для маршрута.' if @stations.size < 2
      start_station = @stations[start_index]
      end_station = @stations[end_index]
      return 'Станции указаны неверно.' unless start_station && end_station
      @routes << Route.new(start_station, end_station)
      true
    end
  
    def assign_route(train_index, route_index)
      return 'Нет поездов или маршрутов!' if @trains.empty? || @routes.empty?
      train = @trains[train_index]
      route = @routes[route_index]
      return 'Некорректный выбор!' unless train && route
      train.assign_route(route)
      true
    end
  
    def add_carriage(train_index)
      train = @trains[train_index]
      return 'Поезд не найден!' unless train
      carriage = train.is_a?(PassengerTrain) ? PassengerCarriage.new : CargoCarriage.new
      train.add_carriage(carriage)
      true
    end
  
    def remove_carriage(train_index)
      train = @trains[train_index]
      return 'Поезд не найден!' unless train
      return 'У поезда нет вагонов!' if train.carriages.empty?
      train.remove_carriage(train.carriages.last)
      true
    end
  
    def move_train_forward(train_index)
      train = @trains[train_index]
      return 'Поезд не найден!' unless train
      return 'У поезда нет маршрута!' unless train.route
      train.move_forward
      train.current_station.name
    end
  
    def move_train_backward(train_index)
      train = @trains[train_index]
      return 'Поезд не найден!' unless train
      return 'У поезда нет маршрута!' unless train.route
      train.move_backward
      train.current_station.name
    end
  
    def list_stations_trains
      @stations.map do |station|
        {
          station: station.name,
          trains: station.trains.map { |t| { number: t.number, type: t.type } }
        }
      end
    end
  end