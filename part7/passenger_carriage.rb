require_relative 'carriage'

class PassengerCarriage < Carriage
    def initialize(total_place)
      super(:passenger, total_place)
    end

    def take_seat
      take_place(1)
    end
  
    def to_s
      "Пассажирский вагон - Свободных мест: #{free_place}, Занятых мест: #{used_place}"
    end
  end
  