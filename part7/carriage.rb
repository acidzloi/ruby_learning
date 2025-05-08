require_relative 'lib/modules'

class Carriage
  include Manufacturer

  attr_reader :type, :total_place, :used_place
  
  def initialize(type, total_place)
    @type = type
    @total_place = total_place
    @used_place = 0
  end

  def free_place
    total_place - used_place
  end

  def take_place(amount)
    raise "Недостаточно свободного места!" if free_place < amount
    @used_place += amount
  end

end