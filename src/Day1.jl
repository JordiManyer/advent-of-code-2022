module Day1

using Aoc22.Helpers

export day1

function parse_line(line)
    return (line=="") ? (-1) : parse(Int,line)
end

function parse_input(filename::String)
    lines = readlines(filename)
    data  = map(parse_line,lines)

    return split_vector(data,-1)
end

function day1()
    filename = "data/day1.txt"
    data = parse_input(filename)
    calories = sort(map(sum,data))
    return calories[end], sum(calories[end-2:end])
end

end