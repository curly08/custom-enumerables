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
    for elem in self
      yield elem, i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    
    case self
    when Array
      result = Array.new
      self.my_each do |elem|
        result.push(elem) if yield(elem)
      end
    when Hash
      result = Hash.new
      self.my_each do |elem|
        result[elem[0]] = elem[1] if yield(elem)
      end
    end
    result
  end
end

include Enumerable

puts "Arrays: my_each vs. each"
numbers = [1, 2, 3, 4, 5]
p numbers.my_select  { |num| num.odd? }
p numbers.select { |num| num.odd? }

puts "\nHashes: my_each vs. each"
fruit = {a: 5, b: 6, c: 3}
p fruit.my_select { |k, v| v == 'cookies' }
p fruit.select { |k, v| v == 'cookies' }
