def find_factors(number)
  factors = []
  (1..Math.sqrt(number).to_i).each do |current_num|
    if (number % current_num).zero? factors.push current_num
    end
  end
  factors.reverse_each do |current_num|
    factors.push((number / current_num).to_i)
  end
  factors
end

def find_gcd(a, b)
  if b.zero?
    a
  else
    find_gcd(b, a % b)
  end
end

def format_factor_string(array, num)
  if array.size == 2
    "#{num} is prime and its factors are {#{array.join(', ')}}"
  else
    "#{num} is composite and its factors are {#{array.join(', ')}}"
  end
end

def power(n, p)
  if p.zero?
    1
  else
    power(n, p - 1) * n
  end
end

def swap_elements(array)
  (0..array.length - 2).step(2).each do |x|
    temp = array[x]
    array[x] = array[x + 1]
    array[x + 1] = temp
  end
end

puts 'Please enter a number: '
num = gets.to_i
puts format_factor_string(find_factors(num), num)

puts 'Enter a second number: '
num2 = gets.to_i
puts "Greatest common divisor is: #{find_gcd(num, num2)}"

puts "#{num}^#{num2} = #{power(num, num2)}"

array = Array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
puts "Original array: {#{array.join(', ')}}"
swap_elements(array)
puts "Array with all elements swapped with their neighbor:
 {#{array.join(', ')}}"
