require_relative 'train'

class CargoTrain < Train
  def initialize(number)
    super(number, "cargo")
  end

  private

  def valid_carriage?(carriage)
    carriage.is_a?(CargoCarriage)
  end
end
