module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    for elem in self
      yield elem
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    for elem in self
      yield elem, i
      i += 1
    end
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

  def my_all?(*arg)
    if block_given?
      self.my_each { |elem| return false unless yield(elem) == true }
    elsif !arg.empty?
      self.my_each { |elem| return false unless arg[0] === elem }
    else
      self.my_each { |elem| return false if elem == false || elem == nil}
    end
    true
  end

  def my_any?(*arg)
    if block_given?
      self.my_each { |elem| return true if yield(elem) == true }
    elsif !arg.empty?
      self.my_each { |elem| return true if arg[0] === elem }
    else
      self.my_each { |elem| return true if elem == true }
    end
    false
  end

  def my_none?(*arg)
    if block_given?
      self.my_each { |elem| return false if yield(elem) == true }
    elsif !arg.empty?
      self.my_each { |elem| return false if arg[0] === elem }
    else
      self.my_each { |elem| return false if elem == true }
    end
    true
  end
end

include Enumerable

puts "Arrays: my_each vs. each"
numbers = [ 2, 3]
p numbers.my_none? {|num| num > 2 }
p numbers.none? {|num| num > 2 }

puts "\nHashes: my_each vs. each"
fruit = {a: 'apple', b: 'pear', c: 'apple'}
p fruit.my_none? { |k, v| v.length == 6 }
p fruit.none? { |k, v| v.length == 6 }
