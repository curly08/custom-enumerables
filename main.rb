module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for elem in self
      yield elem
    end
    # self
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
      self.my_each { |elem| result.push(elem) if yield(elem) }
    when Hash
      result = Hash.new
      self.my_each { |elem| result[elem[0]] = elem[1] if yield(elem) }
    end
    result
  end

  def my_all?
    return to_enum(:my_all?) unless block_given?

    self.my_each { |elem| return false if yield(elem) == false }
    true
  end
end

include Enumerable

puts "Arrays: my_each vs. each"
numbers = %w[ant bee cat]
p numbers.my_all?  { |word| word.length < 3 }
p numbers.all? { |word| word.length >= 4 }

puts "\nHashes: my_each vs. each"
fruit = {a: 'apple', b: 'apple', c: 'apple'}
p fruit.my_all? { |k, v| v == 'apple' }
p fruit.all? { |k, v| v.length == 1 }
