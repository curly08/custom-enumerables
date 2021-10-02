module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for k, v in self
      yield k, v
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    case self
    when Array
      for i in 0..self.size-1 do
        yield self[i], i
      end
    when Hash
      i = 0
      for v in self
        yield v, i
        i += 1
      end
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
p fruit.my_each_with_index  { |(k,v), i| puts "#{i}: #{k} => #{v}" }
p fruit.each_with_index  { |(k,v), i| puts "#{i}: #{k} => #{v}" }