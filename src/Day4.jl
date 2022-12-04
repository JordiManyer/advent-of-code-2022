module Day4

using Aoc22.Helpers

export day4

function parse_branch(branch)
    mid = findfirst(x->x=='-',branch)
    return parse(Int,branch[1:mid-1]), parse(Int,branch[mid+1:end])
end

function parse_line(line)
    mid = findfirst(x->x==',',line)
    return parse_branch(line[1:mid-1]), parse_branch(line[mid+1:end])
end

function parse_input(filename::String)
    lines = readlines(filename)
    data  = map(parse_line,lines)
    return data
end

function contains(a::Tuple{Int,Int},b::Tuple{Int,Int})
    return (a[1] <= b[1]) && (b[2] <= a[2])
end

function redundant(a::Tuple{Int,Int},b::Tuple{Int,Int})
    return contains(a,b) || contains(b,a)
end

function overlaps(a::Tuple{Int,Int},b::Tuple{Int,Int})
    return (a[1] <= b[1] <= a[2]) || (a[1] <= b[2] <= a[2]) || redundant(a,b)
end

function day4()
    filename = "data/day4.txt"
    data = parse_input(filename)

    is_redundant = map(p->redundant(p[1],p[2]),data)
    is_overlapping = map(p->overlaps(p[1],p[2]),data)
    return sum(is_redundant), sum(is_overlapping)
end

end