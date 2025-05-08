class CargoCarriage < Carriage
  
    def initialize(total_volume)
      super(:cargo, total_volume)
    end

    def occupy_volume(amount)
      take_place(amount)
    end
     
    def to_s
      "Грузовой вагон - Свободный объем: #{free_place}, Занятый объем: #{used_place}"
    end
  end