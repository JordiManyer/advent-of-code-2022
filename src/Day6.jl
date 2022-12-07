module Day6

using Aoc22.Helpers

export day6

function parse_input(filename::String)
    lines = readlines(filename)
    return collect(lines[1])
end

function find_marker(msg::Vector{Char})
    n = length(msg)
    k = findfirst(k->unique(msg[k-3:k]) == msg[k-3:k],4:n)
    return k+3
end

function find_msg(msg::Vector{Char})
    n = length(msg)
    k = findfirst(k->unique(msg[k-13:k]) == msg[k-13:k],14:n)
    return k+13
end

function day6()
    filename = "data/day6.txt"
    msg = parse_input(filename)
    return find_marker(msg), find_msg(msg)
end

end