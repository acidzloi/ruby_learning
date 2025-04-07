module Manufacturer
    attr_accessor :manufacturer
end

module InstanceCounter
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end
  
    module ClassMethods
      def instances
        @instances ||= 0
      end
  
      def increment_instances
        @instances ||= 0
        @instances += 1
      end
    end
  
    module InstanceMethods
      private
  
      def register_instance
        self.class.increment_instances
      end
    end
  end

  module Menu
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
      { id: 0, title: 'Выйти', action: :exit_app } 
    ]
  
    def show_menu
      MENU.each { |item| puts "#{item[:id]}. #{item[:title]}" }
    end
  
    def get_choice
      puts 'Выберите действие: '
      gets.chomp.to_i
    end
  
    def take_action(choice)
      item = MENU.find { |menu_item| menu_item[:id] == choice }
      item ? send(item[:action]) : puts('Некорректный ввод, попробуйте снова.')
    end
  end