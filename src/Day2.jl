module Day2

using Aoc22.Helpers

export day2

ABC_to_int = Dict{Char,Int}(
    'A' => 0,
    'B' => 1,
    'C' => 2,
)

XYZ_to_int = Dict{Char,Int}(
    'X' => 0,
    'Y' => 1,
    'Z' => 2,
)

shape_to_score = Dict{Int,Int}(
    0 => 1, # Rock
    1 => 2, # Paper
    2 => 3  # Scisors
)

result_to_score = Dict{Int,Int}(
    0 => 0,
    1 => 3,
    2 => 6
)

function parse_line(line)
    return (ABC_to_int[line[1]],XYZ_to_int[line[3]])
end

function parse_input(filename::String)
    lines = readlines(filename)
    data  = map(parse_line,lines)
    return data
end

function result_from_shapes(a::Int,b::Int)
    return (b-a+3+1)%3
end

function shape_from_result(a::Int,score::Int)
    return (a+score-1+3)%3
end

function score_p1(x::Tuple{Int,Int})
    return result_to_score[result_from_shapes(x...)] + shape_to_score[x[2]]
end

function score_p2(x::Tuple{Int,Int})
    return shape_to_score[shape_from_result(x...)] + result_to_score[x[2]]
end

function day2()
    filename = "data/day2.txt"
    data = parse_input(filename)
    scores1 = map(score_p1,data)
    scores2 = map(score_p2,data)
    return sum(scores1), sum(scores2)
end

end
