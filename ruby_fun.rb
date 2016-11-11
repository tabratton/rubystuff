def find_factors(number)
  factors = Array.new
  (1..Math.sqrt(number).to_i).each do | current_num |
    if number % current_num == 0
      factors.push current_num
    end
  end
  factors.reverse_each do | current_num |
    factors.push (number / current_num).to_i
  end
  factors
end

def find_GCD(a, b) 
  gcd = if b == 0
          a
        else
          find_GCD(b, a % b)
        end
end

def print_factors(array, num)
  string_to_print = if array.size == 2
                      "#{num} is prime and its factors are {#{array.join(', ')}}"
                    else
                      "#{num} is composite and its factors are {#{array.join(', ')}}"
                    end
  puts string_to_print
end

puts 'Please enter a number: '
num = gets.to_i
print_factors(find_factors(num), num)

puts 'Enter a second number: '
num2 = gets.to_i
puts "Greatest common divisor is: #{find_GCD(num, num2)}"
