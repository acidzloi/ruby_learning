require_relative 'modules'

class Train
  include Validation

  attr_accessor :name, :number, :station

  validate :name, :presence
  validate :name, :type, String
  validate :number, :format, /^[A-Z0-9]{3,5}$/
end

train = Train.new
train.name = "Express"
train.number = "AAA12"

puts train.valid?        # => true
train.validate!          # => ничего не выбросит

train.number = "!!"
puts train.valid?        # => false
train.validate!          # => выбросит исключение