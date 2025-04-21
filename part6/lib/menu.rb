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
  
    def self.show_menu
      MENU.map { |item| "#{item[:id]}. #{item[:title]}" }.join("\n")
    end
  
    def self.find_action(choice)
      item = MENU.find { |menu_item| menu_item[:id] == choice }
      item&.dig(:action)
    end
  end