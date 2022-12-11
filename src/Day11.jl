module Day11

using DataStructures

export day11

abstract type OperationType end
struct Add <: OperationType end
struct Mul <: OperationType end

struct Variable end

struct Operation{T<:OperationType,X,Y}
    op :: T
    x  :: X
    y  :: Y
end

apply(::Add,a,b) = a+b
apply(::Mul,a,b) = a*b

function apply(op::Operation{T,Variable,Variable},old::Int) where T
    return apply(op.op,old,old)
end

function apply(op::Operation{T,Variable,Int},old::Int) where T
    return apply(op.op,old,op.y)
end

function apply(op::Operation{T,Int,Variable},old::Int) where T
    return apply(op.op,op.x,old)
end

string_to_op = Dict{String,OperationType}(
    "+" => Add(),
    "*" => Mul()
)

function string_to_var(v)
    if v == "old"
        return Variable()
    else
        return parse(Int,v)
    end
end

struct Test
    div::Int
    partners::Tuple{Int,Int}
end

function test(t::Test,num::Int)
    if num % t.div == 0
        return t.partners[1]+1
    else
        return t.partners[2]+1
    end
end

struct Monkey
    objects :: Queue{Int}
    op      :: Operation
    test    :: Test
end

function parse_operation(line)
    v = split(strip(line),' ')
    return Operation(string_to_op[v[2]],string_to_var(v[1]),string_to_var(v[3]))
end

function parse_test(lines)
    return Test(parse(Int,lines[1][end-1:end]),(parse(Int,lines[2][end]),parse(Int,lines[3][end])))
end

function parse_monkey(lines)
    objects = map(s -> parse(Int,s), split(lines[2][18:end],','))
    op = parse_operation(lines[3][19:end])
    test = parse_test(lines[4:6])

    obj = Queue{Int}()
    map(o -> enqueue!(obj,o),objects)
    return Monkey(obj,op,test)
end

function next_round_p1!(monkeys::Vector{Monkey})
    counts = fill(0,length(monkeys))
    for (k,m) in enumerate(monkeys)
        while !isempty(m.objects)
            old_wl = dequeue!(m.objects)
            new_wl = apply(m.op,old_wl)÷3
            new_monkey = test(m.test,new_wl)
            enqueue!(monkeys[new_monkey].objects,new_wl)
            counts[k] += 1
        end
    end
    return counts
end

function next_round_p2!(monkeys::Vector{Monkey},factor::Int)
    counts = fill(0,length(monkeys))
    for (k,m) in enumerate(monkeys)
        while !isempty(m.objects)
            old_wl = dequeue!(m.objects)
            new_wl = apply(m.op,old_wl)%factor
            new_monkey = test(m.test,new_wl)
            enqueue!(monkeys[new_monkey].objects,new_wl)
            counts[k] += 1
        end
    end
    return counts
end

function N_rounds_p1(monkeys::Vector{Monkey},N::Int)
    counts = fill(0,length(monkeys))
    for k in 1:N
        """
        println("Round: ", k)
        for (i,m) in enumerate(monkeys)
            println("Monkey ", i, ": ", m.objects)
        end
        """
        counts .+= next_round_p1!(monkeys)
    end
    return counts
end

function N_rounds_p2(monkeys::Vector{Monkey},N::Int)
    factor = prod(map(m->m.test.div,monkeys))
    counts = fill(0,length(monkeys))
    for k in 1:N
        """
        println("Round: ", k)
        for (i,m) in enumerate(monkeys)
            println("Monkey ", i, ": ", m.objects)
        end
        """
        counts .+= next_round_p2!(monkeys,factor)
    end
    return counts
end

function parse_input(filename::String,n::Int)
    lines = readlines(filename)
    monkeys = Vector{Monkey}(undef,n)
    for k in 0:n-1
        monkeys[k+1] = parse_monkey(lines[k*7+1:(k+1)*7])
    end
    return monkeys
end

function day11()
    filename = "data/day11.txt"
    monkeys = parse_input(filename,8)
    counts1 = N_rounds_p1(monkeys,20)
    monkey_business1 = prod(sort(counts1;rev=true)[1:2])

    monkeys = parse_input(filename,8)
    counts2 = N_rounds_p2(monkeys,10000)
    monkey_business2 = prod(sort(counts2;rev=true)[1:2])

    return monkey_business1, monkey_business2
end

end