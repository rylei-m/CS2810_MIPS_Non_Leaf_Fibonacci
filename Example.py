def fib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    return fib(n-1) + fib(n - 2)

def print_array(array):
    for num in array:
        print(num, end=" ")
    print()

def main():
    array = []
    num = int(input("Please enter a fibonacci number: "))

    for i in range(num):
        array.append(fib(i))
        print_array(array)


main()