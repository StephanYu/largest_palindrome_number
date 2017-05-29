require 'pry-byebug'

def numeric_palindrome(*args)
  arguments = create_combinations_from(*args)
  max_number = get_max_number_from(arguments)
  results = []

  arguments.each do |argument|
    split_args = argument.to_s.split('')
    count_map = create_count_map(split_args)

    if palindromable?(count_map)
      results << largest_palindrome(count_map)
    else
      next
    end
  end

  return max_number if results.empty?
  results.max > max_number ? results.max : max_number
end

def create_count_map(arguments)
  count_map = Hash.new(0)
  arguments.each { |num| count_map[num.to_i] += 1 }

  count_map
end

def palindromable?(counts)
  # dealing with edge cases where 4 or 8 digit numbers with only uneven counts can still be a numeric palindrome ie(4999 -> 494)
  return true if [4, 8].include?(counts.values.inject(:+)) && counts.values.map(&:odd?).include?(true)

  counts.values.map(&:even?).include?(true)
end

def largest_palindrome(count_map)
  results = []
  # select center digit by choosing uneven count number with highest value
  uneven_counts_keys = count_map.select { |_key, value| value.odd? }.keys
  center = uneven_counts_keys.max

  # take all remaining digits * count/2 and create selection for front half
  count_map.each do |key, value|
    count_map[key] -= 1 if uneven_counts_keys.include?(key)
    results << key.to_s * (value / 2)
  end

  # create all permutations from this array and choose max
  permutations = results.permutation.to_a.delete_if { |perm| perm.join.to_i.zero? }
  largest_perm = permutations.map(&:join).max

  front = largest_perm
  back = largest_perm.nil? ? nil : largest_perm.reverse

  final_palindrome = "#{front}#{center}#{back}".to_i
end

def get_max_number_from(arguments)
  arguments.join.split('').max.to_i
end

def filter(arguments)
  arguments.delete_if { |arg| arg.zero? || arg == 1 }
end

def create_combinations_from(*arguments)
  new_arguments = []
  filter(arguments)
  return [] if arguments.empty?

  if arguments.length == 1
    new_arguments << arguments
  else
    arguments.length.downto(2) do |num|
      new_arguments << arguments.combination(num).to_a.map { |arr| arr.inject(:*) }
    end
  end

  new_arguments.flatten
end

p numeric_palindrome(307, 91897)
