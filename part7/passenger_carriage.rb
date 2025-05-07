require_relative 'carriage'

class PassengerCarriage < Carriage
    attr_reader :type, :total_seats, :occupied_seats
  
    def initialize(total_seats)
      super(:passenger)
      @total_seats = total_seats
      @occupied_seats = 0
    end

    def take_seat
      raise 'No available seats' if full?
  
      @occupied_seats += 1
    end
  
    def free_seats
      @total_seats - @occupied_seats
    end
  
    def full?
      @occupied_seats >= @total_seats
    end

    def to_s
      "Пассажирский вагон - Свободных мест: #{free_seats}, Занятых мест: #{occupied_seats}"
    end
  end
  