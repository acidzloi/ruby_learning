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

    attr_reader :name, :trains

    def initialize(name)
      @name = name
      @trains = []
    end

    def accept_train(train)
      @trains << train
    end

    def list_trains
      puts @trains
    end

    def list_trains_by_type(type)
      puts @trains.select { |train| train.type == type } 
    end

    def send_train(train)
      @trains.delete(train)
    end

end

class Route

    attr_reader :stations

    def initialize(start_station, end_station)
      @stations = [start_station, end_station]
    end

    def add_station(station)
      @stations.insert(-2, station)
    end

    def delete_station(station)
      @stations.delete(station) if @stations.include?(station) && @stations.size > 2
    end

    def stations_list
      stations.each do |station|
        puts station
      end
    end
end

class Train

    attr_reader :number, :type, :carriages, :current_station

  def initialize(number, type, carriages)
    @number = number
    @type = type
    @carriages = carriages
    @speed = 0
    @route = nil
    @current_station = 0
  end


  def accelerate(increment)
    @speed += increment
  end

  def current_speed
    puts @speed
  end

  def brake
    @speed = 0
  end

  def carriage_count
    puts @carriage
  end

  def carriage_count
    puts @carriage
  end

  def attach_carriage
    if @speed > 0
      puts "Поезд движется, нельзя прицепить вагон"
    else
      @carriages += 1
    end
  end

  def detach_carriage
    if @speed > 0
      puts "Поезд движется, нельзя отцепить вагон"
    else
      @carriages -= 1
    end
  end

  def assign_route(route)
    @route = route
    @current_station = 0
    current_station.accept_train(self)
  end

  def current_station
      @route.stations[@current_station]
  end

  def previous_station
    if @current_station == 0
      return nil
    else
      @route.stations[@current_station - 1]
    end
  end

  def next_station
    if @current_station == @route.stations.length - 1
      return nil
    else
      @route.stations[@current_station +1]
    end
  end
  
  def move_forward
    puts "Поезд не назначен на маршрут" unless @route
    puts "Поезд уже на последней станции" if @current_station >= @route.stations.size - 1

    current_station.send_train(self) # Отправляем поезд с текущей станции
    @current_station += 1
    next_station.accept_train(self) # Принимаем поезд на следующей станции
  end

  def move_backward
    puts "Поезд не назначен на маршрут" unless @route
    puts "Поезд уже на первой станции" if @current_station <= 0

    current_station.send_train(self) # Отправляем поезд с текущей станции
    @current_station -= 1
    previous_station.accept_train(self) # Принимаем поезд на предыдущей станции
  end

end
