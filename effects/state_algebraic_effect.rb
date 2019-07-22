require 'fiber'

module State
  class Effects
    def read
      Fiber.yield(:read)
    end

    def write(value)
      Fiber.yield(:write, value)
    end
  end

  class Handler
    def call(initial_state)
      instructions_inside_fiber = ::Fiber.new { yield }
      state = initial_state

      result = instructions_inside_fiber.resume

      fiber_result = loop do
        # if fiber is dead, we've exhuasted all of instructions.
        break result unless instructions_inside_fiber.alive?

        effect, *payload = result

        case effect
        when :read
          result = instructions_inside_fiber.resume(state)
        when :write
          state = payload[0]
          result = instructions_inside_fiber.resume
        end
      end

      [state, fiber_result]
    end
  end
end

# How to use:

state_handler = State::Handler.new

state_effects = State::Effects.new

state, result = state_handler.(0) do
  state_effects.write(state_effects.read + 1)
  :done
end

puts "State is correct" if state == 1
puts "Result is correct" if result == :done

# Explanation

# state_handler.(0) do
#   ...
# end

# We run Handler class here.
# fiber variable we'll point to a Fiber with do ... end block inside

# def call(0)
#   instructions_inside_fiber = ::Fiber.new { yield }
#   state = 0

#   # We are executing first instruction here:

#   result = instructions_inside_fiber.resume => state_effects.read

#   # state_effects.read is just a Fiber.yield(:read)
#   # so we are quickly getting back here
#   # and result is :read, like this

#   result = instructions_inside_fiber.resume => :read

#   fiber_result = loop do
#     # if fiber is dead, we've exhuasted all of the instructions.
#     break result unless instructions_inside_fiber.alive?

#     effect, *payload = result # effect=:read, payload=[]

#     case effect # :read
#     when :read
#       result = instructions_inside_fiber.resume(state) => run next instructions with state(0)
#       # So, we are resuming to second instruction here
#       # And this instruction is state_effects.write(0 + 1) == state_effects.write(1)
#       # state_effects.write() implementation is Fiber.yield(:write, value)
#       # so we are getting back here and result equals to [:write, 1]
#       # and we are going to the next cycle iteration
#     when :write
#       state = payload[0]
#       result = instructions_inside_fiber.resume
#     end
#   end

#   [state, fiber_result]
# end


# Next iteration of loop


# def call(0)
#   instructions_inside_fiber = ::Fiber.new { yield }
#   state = 0

#   result = instructions_inside_fiber.resume

#   # WE ARE HERE!
#   fiber_result = loop do
#     break result unless instructions_inside_fiber.alive?

#     effect, *payload = result # effect=:write, payload=[1]

#     case effect # :write
#     when :read
#       result = instructions_inside_fiber.resume(state)
#     when :write
#       state = payload[0] => this is 1, so we've updated the state here
#       result = instructions_inside_fiber.resume
#       # next instruction is the last one in instruction set
#       # this is just return of :done symbol
#       # so result is equal to :done
#     end
#   end

#   [state, fiber_result]
# end


# Next iteration of loop


# def call(0)
#   instructions_inside_fiber = ::Fiber.new { yield }
#   state = 0

#   result = instructions_inside_fiber.resume

#   # WE ARE HERE!
#   fiber_result = loop do
#     # We are at the line with :done instruction and fiber is NOT alive anymore
#     # so we are just breaking out with result
#     break result unless instructions_inside_fiber.alive?

#     effect, *payload = result

#     case effect
#     when :read
#       result = instructions_inside_fiber.resume(state)
#     when :write
#       state = payload[0]
#       result = instructions_inside_fiber.resume
#     end
#   end

#   [state, fiber_result]
# end
