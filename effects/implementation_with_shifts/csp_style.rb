# CPS style interpreter implementation.

def evalulate(exp, env, next_)
  if exp.is_a? Numeric
    puts "Numeric: #{exp}, env: #{env}"
    next_.(exp)
  elsif exp.is_a? String
    puts "String: #{exp}, env: #{env}"
    next_.(env[exp])
  elsif exp[:type] == "add"
    puts "add: #{exp}, env: #{env}"
    evalulate(exp[:exp1], env, ->(v1) {
        puts "In function: #{exp}, env: #{env}"
        evalulate(exp[:exp2], env, ->(v2) {
            puts "Before addition: #{exp}, env: #{env}"
            next_.(v1 + v2)
          })
      })
  elsif exp[:type] == "fun"
    puts "fun: #{exp}, env: #{env}"
    f = -> (value, next_) do
      puts "building Lambda env: #{exp}, env: #{env}"
      fun_env = env.merge({ exp[:param] => value })
      puts "evaling lambda: #{exp}, env: #{env}"
      evalulate(exp[:body], fun_env, next_)
    end

    puts "fun: #{exp}, env: #{env}"
    next_.(f)
  elsif exp[:type] == "call"
    puts "call: #{exp}, env: #{env}"
      evalulate(exp[:fun_exp], env, ->(fun_value) {
          puts "call_second: #{exp}, env: #{env}"
          evalulate(exp[:arg_exp], env, ->(arg_value) {
              puts "call_final: #{exp}, env: #{env}"
              fun_value.(arg_value, next_)
            })
      })
  end
end

def fun(param, body)
  {type: "fun", param: param, body: body}
end

def call(fun_exp, arg_exp)
  {type: "call", fun_exp: fun_exp, arg_exp: arg_exp}
end

def add(exp1, exp2)
  {type: "add", exp1: exp1, exp2: exp2}
end

double_fun = fun("x", add("x", "x"))

program = call(double_fun, 10)

puts (evalulate program, {}, ->(x) { x })
