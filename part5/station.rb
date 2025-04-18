require_relative 'modules'

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


end