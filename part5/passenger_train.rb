require_relative 'train'

class PassengerTrain < Train
  def initialize(number)
    super(number, "passenger")
  end

  private

  def valid_carriage?(carriage)
    carriage.is_a?(PassengerCarriage)
  end
end
