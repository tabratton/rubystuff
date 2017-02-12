def power(n, p)
	if p == 0
	  1
	else
		power(n, p - 1) * n
	end
end

puts power(50, 5)