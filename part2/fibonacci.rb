# Заполнить массив числами фибоначчи до 100
def fibonacci( n )
    if n < 3
        1
    else
        fibonacci(n - 1) + fibonacci(n - 2)
    end
end

fibonacci_num = []
num  = 0
count = 1

while num < 100
    fibonacci_num << num
    num = fibonacci(count)
    count = count +1
end 

puts fibonacci_num.inspect
