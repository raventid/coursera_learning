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

puts program
