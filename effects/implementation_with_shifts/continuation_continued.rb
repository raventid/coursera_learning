require "fiber"

def greet1(name)
  message = "Hi, #{name}"
  message
end

puts greet1("Friend")

# just return a fiber
def greet(name)
  Fiber.new {
    message = Fiber.yield "Hi, #{name}"
    message
  }
end

# drive fiber to completion
def run_fiber(fiber, arg)
  value = fiber.resume(arg)
  if fiber.alive?
    fiber.resume(value)
  else
    value
  end
end

puts greet("Friend")

puts run_fiber(greet("Friend"), nil)



def factorial(n)
  Fiber.new {
    do_factorial(n)
  }
end

def do_factorial(n)
  return 1 if n == 0
  n1 = Fiber.yield do_factorial(n - 1)
  n * n1
end

puts run_fiber(factorial(10), nil)
