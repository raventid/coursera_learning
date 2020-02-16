# CPS style interpreter implementation.

def evalulate(exp, env, next_)
  if exp.is_a? Numeric
    exp
  elsif exp.is_a? String
    env[exp]
  elsif exp[:type] == "add"
    evalulate(exp[:exp1], env, ?) + evalulate(exp[:exp2], env, ?)
  elsif exp[:type] == "fun"
    -> (value) do
      fun_env = env.merge({ exp[:param] => value })
      evalulate(exp[:body], fun_env, ?)
    end
  elsif exp[:type] == "call"
    fun_value = evalulate(exp[:fun_exp], env, ?) # to use CPS I should use callbacks here!
    arg_value = evalulate(exp[:arg_exp], env, ?) # I need a diagram with explanation
    fun_value.(arg_value)
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

puts (evalulate program, {})
