# Просмотреть код своего проекта и попробовать применить рассмотренные идиомы там, где это возможно.
# Изучить Ruby Style Guide (ссылка в материалах к уроку). Рекомендую знакомиться с английским вариантом, а русский использовать только для непонятных мест. Английский вариант наиболее актуальный, кроме того, в русском есть неточности.
# Посмотреть мастер-класс "Почему код должен быть стильным" (ссылка в материалах к уроку)
# Установить rubocop и проанализировать свой проект с его помощью
# Исправить все ошибки (кроме отсутствия документации), которые выдаст rubocop. То, что он не сможет исправить в автоматическом режиме, исправить вручную. Залить исправленные версии на гитхаб.

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'lib/modules'

class Main
  MENU = [
    { id: 1, title: 'Создать станцию', action: :create_station },
    { id: 2, title: 'Создать поезд', action: :create_train },
    { id: 3, title: 'Создать маршрут', action: :create_route },
    { id: 4, title: 'Назначить маршрут поезду', action: :assign_route },
    { id: 5, title: 'Добавить вагон к поезду', action: :add_carriage },
    { id: 6, title: 'Отцепить вагон от поезда', action: :remove_carriage },
    { id: 7, title: 'Переместить поезд вперед', action: :move_train_forward },
    { id: 8, title: 'Переместить поезд назад', action: :move_train_backward },
    { id: 9, title: 'Просмотреть список станций и поездов на станциях', action: :list_stations_trains },
    { id: 10, title: 'Просмотреть список вагонов у поезда', action: :list_carriages_of_train },
    { id: 11, title: 'Просмотреть список поездов на станции', action: :list_trains_on_station_action },
    { id: 12, title: 'Занять место или объем в вагоне', action: :occupy_seat_or_volume },
    { id: 0, title: 'Выйти', action: :exit_app }
  ].freeze

  def initialize
    @data_manager = DataManager.new
    @ui = UserInterface.new(@data_manager)
  end

  def start
    loop do
      @ui.show_menu(MENU)
      choice = @ui.take_choice
      @ui.handle_action(choice, MENU)
    end
  end
end

class DataManager
  attr_accessor :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end
end

class UserInterface
  include MenuMethods
  include CreationMethods
  include TrainManagementMethods
  include DisplayMethods
  include OccupyMethods
  include HelperMethods

  def initialize(data_manager)
    @data_manager = data_manager
  end
end

Main.new.start
