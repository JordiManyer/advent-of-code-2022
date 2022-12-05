module Day5

using Aoc22.Helpers
using DataStructures

export day5

function parse_box(s::String)
    x = strip(s)
    return (x=="") ? '-' : x[2]
end

function parse_crane_line(line::String)
    n = length(line)
    return [parse_box(line[k:min(k+3,n)]) for k in 1:4:n-2]
end

function parse_move_line(line::String)
    v = split(line,' ')
    return (parse(Int,v[2]),parse(Int,v[4]),parse(Int,v[6]))
end

function parse_input(filename::String)
    lines      = readlines(filename)
    crane_data = map(parse_crane_line,lines[1:8])
    moves      = map(parse_move_line,lines[11:end])

    nCranes = length(crane_data[1])
    height  = length(crane_data)
    cranes  = [Stack{Char}() for i in 1:nCranes]
    for iC in 1:nCranes
        for iH in height:-1:1
            if crane_data[iH][iC] != '-'
                push!(cranes[iC],crane_data[iH][iC])
            end
        end
    end

    return cranes, moves
end

function move_boxes1!(cranes::Vector{Stack{Char}},m::Tuple{Int,Int,Int})
    for n in 1:m[1]
        c = pop!(cranes[m[2]])
        push!(cranes[m[3]],c)
    end
end

function move_boxes2!(cranes::Vector{Stack{Char}},m::Tuple{Int,Int,Int})
    c = Vector{Char}(undef,m[1])
    for i in m[1]:-1:1
        c[i] = pop!(cranes[m[2]])
    end
    for i in 1:m[1]
        push!(cranes[m[3]],c[i])
    end
end

function day5()
    filename = "data/day5.txt"
    cranes, moves = parse_input(filename)

    cranes1, moves = parse_input(filename)
    map(m->move_boxes1!(cranes1,m),moves)
    top1 = string(map(pop!,cranes1)...)

    cranes2, moves = parse_input(filename)
    map(m->move_boxes2!(cranes2,m),moves)
    top2 = string(map(pop!,cranes2)...)
    
    return top1,top2
end

end