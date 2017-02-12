def swap_elements(array)
  (0..array.length - 2).step(2).each do | x |
    temp = array[x]
    array[x] = array[x + 1]
    array[x + 1] = temp
  end
end

array = Array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
swap_elements(array)
puts "{#{array.join(', ')}}"