module Day10

using Aoc22.Helpers

export day10

abstract type Instruction end
struct AddX <: Instruction
    a::Int
end
struct Noop <: Instruction end

cycles(::Noop) = 1
cycles(::AddX) = 2

function apply!(::Noop, k::Int, series::Vector{Int})
    series[k] = series[k-1]
    return k+1
end

function apply!(I::AddX, k::Int, series::Vector{Int})
    series[k]   = series[k-1]
    series[k+1] = series[k-1] + I.a
    return k+2
end

function parse_line(line::String)
    v = split(line,' ')
    if length(v) == 1
        return Noop()
    else
        return AddX(parse(Int,v[2]))
    end
end

function parse_input(filename::String)
    lines = readlines(filename)
    return map(parse_line,lines)
end

function do_cycles(instructions::Vector{Instruction})
    ncycles = 1
    for I in instructions
        ncycles += cycles(I)
    end

    series = Vector{Int}(undef,ncycles)

    cycle  = 2
    series[1] = 1
    for I in instructions
        cycle = apply!(I,cycle,series)
    end

    return series
end

function render_image(series::Vector{Int})
    n = length(series)

    screen = Vector{Char}(undef,n-1)
    for k in 1:n-1
        screen[k] = ((k-1)%40+1 ∈ series[k+1]-1:series[k+1]+1) ? '#' : '.'
    end

    return screen
end

function print_image(screen)
    for k in 1:6
        range = (k-1)*40+1:k*40
        println(string(screen[range]...))
    end
end

function day10()
    filename = "data/day10.txt"
    instructions = parse_input(filename)

    series = do_cycles(instructions)

    idx = [20, 60, 100, 140, 180, 220]
    signal_strength = sum(map(i->i*series[i],idx))

    screen = render_image(series)
    print_image(screen)

    return signal_strength
end

end