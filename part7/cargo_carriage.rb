class CargoCarriage
    attr_reader :type, :total_volume, :occupied_volume
  
    def initialize(total_volume)
      super(:cargo)
      @total_volume = total_volume
      @occupied_volume = 0.0
    end

    def occupy_volume(amount)
      raise 'Not enough available volume' if amount > available_volume
  
      @occupied_volume += amount
    end
  
    def available_volume
      @total_volume - @occupied_volume
    end
    
    def to_s
      "Грузовой вагон - Свободный объем: #{free_volume}, Занятый объем: #{occupied_volume}"
    end
  end