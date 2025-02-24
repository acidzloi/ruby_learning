=begin
Класс Station (Станция):

    Имеет название, которое указывается при ее создании
    Может принимать поезда (по одному за раз)
    Может возвращать список всех поездов на станции, находящиеся в текущий момент
    Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
    Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

Класс Route (Маршрут):

    Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
    Может добавлять промежуточную станцию в список
    Может удалять промежуточную станцию из списка
    Может выводить список всех станций по-порядку от начальной до конечной

Класс Train (Поезд):

    Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
    Может набирать скорость
    Может возвращать текущую скорость
    Может тормозить (сбрасывать скорость до нуля)
    Может возвращать количество вагонов
    Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
    Может принимать маршрут следования (объект класса Route). 
    При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
    Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

=end

class Station

    def name
      @name
    end

    def trains
      @trains
    end

    def initialize(name)
      name = name
      trains = []
    end

    def accept_train(train)
      trains << train
    end

    def list_trains
      trains
    end

    def list_trains_by_type(type)
      trains.select { |train| train.type == type } 
    end

    def send_train(train)
      trains.delete(train)
    end

end

class Route

    def stations
      @stations
    end

    def initialize(start_station, end_station)
      stations = [start_station, end_station]
    end

    def add_station(station)
      stations.insert(-2, station)
    end

    def delete_station(station)
      stations.delete(station) if stations.include?(station) && stations.size > 2
    end

    def stations_list
      stations.each do |station|
        station
      end
    end
end

class Train

    attr_reader :number

  def number
    @number
  end  

  def type
    @type
  end  

  def carriages
    @carriages
  end  

  def current_station_index
    @current_station_index
  end

  def initialize(number, type, carriages)
    number = number
    type = type
    carriages = carriages
    @speed = 0
    @route = nil
    current_station_index = 0
  end


  def accelerate(increment)
    @speed += increment
  end

  def current_speed
    @speed
  end

  def brake
    @speed = 0
  end

  def carriage_count
    @carriage
  end

  def attach_carriage
    carriages += 1 if @speed == 0
  end

  def detach_carriage
    carriages -= 1 if @speed == 0 && carriages > 0
  end

  def assign_route(route)
    @route = route
    current_station_index = 0
    current_station.accept_train(self)
  end

  def current_station
    @route.stations[current_station_index]
  end

  def previous_station
      @route.stations[current_station_index - 1] if current_station_index > 0
  end

  def next_station
      @route.stations[current_station_index +1]
  end
  
  def move_forward
    return unless next_station
    current_station.send_train(self) # Отправляем поезд с текущей станции
    current_station_index += 1
    next_station.accept_train(self) # Принимаем поезд на следующей станции
  end

  def move_backward
    return unless previous_station
    current_station.send_train(self) # Отправляем поезд с текущей станции
    current_station_index -= 1
    previous_station.accept_train(self) # Принимаем поезд на предыдущей станции
  end

end
