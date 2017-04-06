HELLO_WORLD = "Hello world!" # => "Hello world!"

HELLO_WORLD = "Hi world!" # => "Hi world!"

puts HELLO_WORLD # => nil

a = 2 # => 2

b = 3 # => 3

c = a + b # => 5

v = 10 # => 10

class Hello
    attr_reader :name

	def initialize(name)
		@name = name
	end

	def print_name
		puts name
		"I've printed your to the screen, #{name}"
	end
end

h = Hello.new "Julian"

h.print_name # => nil

# >> Hi world!
# >> Julian
