module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    
    for k, v in self
      yield k, v
    end
  end
end

include Enumerable

puts "Arrays: my_each vs. each"
numbers = [1, 2, 3, 4, 5]
p numbers.my_each  #{ |item| puts item }
numbers.each  { |item| puts item }

puts "Hashes: my_each vs. each"
fruit = {a: 'apples', b: 'bananas', c: 'cookies'}
p fruit.my_each  { |k, v| puts v }
p fruit.each  { |k, v| puts v }
