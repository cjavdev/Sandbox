def my_curry_sum x
  sum = 0
  
  sum_prc = lambda do |n|
    sum += n
    x -= 1
    return sum if x == 0
    return sum_prc 
  end
  
  return sum_prc 
end

sum = my_curry_sum(3)

p sum[1][2][3]
