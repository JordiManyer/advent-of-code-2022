module Day9

using Aoc22.Types
using Aoc22.Helpers

export day9

char_to_dir = Dict{Char,Direction}(
    'U' => Up(),
    'D' => Down(),
    'L' => Left(),
    'R' => Right()
)

function parse_line(line::String)
    return (char_to_dir[line[1]],parse(Int,line[3:end]))
end

function parse_input(filename::String)
    lines = readlines(filename)
    return map(parse_line,lines)
end

function print_board(N,M,head,tail)
    board = fill('.',N,M)
    board[tail] = 'T'
    board[head] = 'H'
    display(board)
end

function get_map_size(mvts::Vector{Movement})
    N = sum(m->m[2],filter(m->isa(m[1],Up)||isa(m[1],Down),mvts))
    M = sum(m->m[2],filter(m->isa(m[1],Left)||isa(m[1],Right),mvts))
    return (N,M)
end

function expand_movement(m::Movement)
    return fill((m[1],1),m[2])
end

function move_tail(head,tail)
    v = head - tail
    if (abs(v[1]) > 1 || abs(v[2]) > 1)
        dv = CartesianIndex(sign.(Tuple(v)))
        return tail + dv
    else
        return tail
    end
end

function compute_itinerary(mvts::Vector{Movement})
    N, M = get_map_size(mvts)
    visited = fill(false,(N,M))

    head = CartesianIndex(N÷2,M÷2)
    tail = CartesianIndex(N÷2,M÷2)
    visited[head] = true
    for m in mvts
        steps = expand_movement(m)
        for mi in steps
            head = move(mi,head)
            tail = move_tail(head,tail)
            visited[tail] = true
        end
    end

    return visited
end

function compute_itinerary_N(mvts::Vector{Movement},nKnots::Int)
    N, M = get_map_size(mvts)
    visited = fill(false,(N,M))

    knots = fill(CartesianIndex(N÷2,M÷2),nKnots+1)
    visited[knots[1]] = true
    for m in mvts
        steps = expand_movement(m)
        for mi in steps
            knots[1] = move(mi,knots[1])
            for k in 2:nKnots+1
                knots[k] = move_tail(knots[k-1],knots[k])
                (k == nKnots) && (visited[knots[k]] = true)
            end
        end
    end

    return visited
end

function day9()
    filename = "data/day9.txt"
    mvts = parse_input(filename)   
    visited1 = compute_itinerary(mvts)
    visited2 = compute_itinerary_N(mvts,10)
    return count(visited1), count(visited2)
end

end