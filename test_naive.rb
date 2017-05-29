require 'pry-byebug'

def numeric_palindrome(*args)
  results = []
  arguments = create_combinations_from(*args)
  max_number = get_max_number_from(arguments)

  arguments.each do |argument|
    argument_splitted = argument.to_s.split('')

    argument_splitted.length.downto(2) do |count|
      permutations = argument_splitted.permutation(count).to_a

      permutations.each do |permutation|
        permutation_num = permutation.join.to_i
        next unless palindrome?(permutation_num)
        next if permutation_num.to_s.length < count

        results << permutation_num if permutation_num > max_number
      end
      return results.max if results.any? && results.max.to_s.length == count
    end
  end

  max_number
end

def get_max_number_from(arguments)
  arguments.join.split('').max.to_i
end

def palindrome?(number)
  number.to_s == number.to_s.reverse
end

# Alternative to palindrome?
def palindrome_opt?(number)
  palindrome = number.to_s
  first = 0
  last = palindrome.length - 1

  while first <= last
    return false if palindrome[first] != palindrome[last]
    first += 1
    last -= 1
  end

  true
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

  new_arguments.flatten.sort { |a, b| b <=> a }
end

def assert_equal(actual, expected)
  if actual == expected
    puts "Test Passed: Value == #{actual}"
  else
    puts "Failed, expected #{expected}, got #{actual}"
  end
end

require 'timeout'

puts 'Basic tests...'

Timeout::timeout(1.2) do
  assert_equal(numeric_palindrome(2824, 2399), 7764677)

  assert_equal(numeric_palindrome(888, 91), 80808)

  assert_equal(numeric_palindrome(937, 113), 81518)

  assert_equal(numeric_palindrome(34735, 56), 191)

  assert_equal(numeric_palindrome(15, 125, 8), 8)

  assert_equal(numeric_palindrome(57, 62, 23), 82128)

  assert_equal(numeric_palindrome(48, 9, 3, 0, 67), 868)

  assert_equal(numeric_palindrome(11, 1), 11)

  assert_equal(numeric_palindrome(0, 0, 0), 0)

  assert_equal(numeric_palindrome(2211, 1, 1, 1), 2112)
end

require 'set'

puts 'Random tests'

def randint(a, b)
  rand(b - a + 1) + a
end

def sol(*args)
  args = args.select {|x| x > 0}

  return 0 if args.length < 2

  if args.index(1) != nil
    args = args.select {|x| x>1}+[1]
  end

  if args.length==1
    return sol_max_pal(args[0].to_s.split(''))
  end

  maxval = -1
  sol_get_combo(args, 2).each {|prod|
    maxval=[maxval, sol_max_pal(prod.inject(:*).to_s.split(""))].max
  }

  maxval
end

def sol_get_combo(array, n)
  res = []

  for number in array
    for item in res
      res += [item + [number]]
    end
    res += [[number]]
  end

  res.select {|x| x.length >= n}
end

def sol_max_pal(array)
  even, odd = [], []

  array.to_set.each {|n|
    if array.count(n) > 1
      even += [n*(array.count(n)/2)]
    end
    if array.count(n)%2==1
      odd += [n]
    end
  }
  even.sort!
  odd = odd.length == 0 ? [''] : odd
  if even.length == 1 and even[0][0] == '0'
    even = []
  end
  (even.reverse + [odd.max] + even).join('').to_i
end

Timeout::timeout(1.2) do
  40.times do
    array=[]

    randint(2, 10).times do
      array += [randint(0, 10**randint(1, 5))]
    end
    assert_equal(numeric_palindrome(*([]+array)), sol(*array))
  end
end
