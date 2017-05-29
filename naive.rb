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

p numeric_palindrome(307, 91897)
