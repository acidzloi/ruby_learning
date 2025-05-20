require_relative 'modules'

class People
  extend Accessors

  attr_accessor_with_history :name, :age
  strong_attr_accessor :score, Integer
end

t = People.new
t.name = "Vasya"
t.name = "Petya"
t.name = "Ivan"
puts t.name_history.inspect  # => ["Vasya", "Petya"]

t.score = 42                # OK
t.score = "wrong"           # => raises TypeError