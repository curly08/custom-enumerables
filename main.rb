require 'pry-byebug'

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
      raise ArgumentError unless arg.count == 1

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
      raise ArgumentError unless arg.count == 1

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
      raise ArgumentError unless arg.count == 1

      self.my_each { |elem| return false if arg[0] === elem }
    else
      self.my_each { |elem| return false if elem == true }
    end
    true
  end

  def my_count(*arg)
    i = 0

    if block_given?
      self.my_each { |elem| i += 1 if yield(elem) == true }
    elsif !arg.empty?
      raise ArgumentError unless arg.count == 1

      self.my_each { |elem| i += 1 if arg[0] === elem }
    else
      i = self.size
    end

    i
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    result = Array.new
    self.my_each { |elem| result.push(yield(elem)) }
    result
  end

  def my_inject(*arg)
    if arg.empty?
      raise LocalJumpError unless block_given?

      memo = self.first
      self[1..-1].my_each { |elem| memo = yield memo, elem }
    elsif arg.count == 1
      if block_given?
        raise NoMethodError unless arg[0].is_a?(Integer) || arg[0].is_a?(Float)

        memo = arg[0]
        self.my_each { |elem| memo = yield memo, elem }
      else
        raise Error unless arg[0].is_a?(Symbol)

        memo = self.first
        self[1..-1].my_each { |num| memo = memo.send arg[0], num }
      end
    elsif arg.count == 2
      raise ArgumentError if block_given?
      raise NoMethodError unless arg[0].is_a?(Integer) || arg[0].is_a?(Float) && arg[1].respond_to?(id2name)
      
      memo = arg[0]
      self.my_each { |num| memo = memo.send arg[1], num }
    elsif arg.count > 2
      raise ArgumentError
    end
    memo
  end
end

include Enumerable

puts "Arrays: my_each vs. each"
numbers = %w{ cat sheep bear }
longest = %w{ cat sheep bear }.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest
longest = %w{ cat sheep bear }.inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest

puts "\nHashes: my_each vs. each"
fruit = {a: 'pear', b: 'aple', c: 'dog'}
p fruit.my_inject(0) {|memo, (key, val)| memo += val}
p fruit.inject(0) {|memo, (key, val)| memo += val}
