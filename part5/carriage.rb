require_relative 'modules'

class Carriage
  include Manufacturer

  attr_reader :type
  
  def initialize(type)
    @type = type
  end
end