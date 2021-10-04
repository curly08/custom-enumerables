module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for elem in self
      yield elem
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    self.my_each do |elem|
      yield elem, i
      i += 1
    end
    self
  end
end

include Enumerable

puts "Arrays: my_each vs. each"
numbers = [1, 2, 3, 4, 5]
p numbers.my_each_with_index  { |item, index| puts "Index: #{index} Value: #{item}" }
p numbers.each_with_index  { |item, index| puts item }

puts "Hashes: my_each vs. each"
fruit = {a: 'apples', b: 'bananas', c: 'cookies'}
p fruit.my_each_with_index { |k, i| puts "Index: #{i},#{k} => " }
p fruit.each_with_index { |k, i| puts "Index: #{i},#{k} => " }
