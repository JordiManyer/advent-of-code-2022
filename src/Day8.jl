module Day8

using Aoc22.Types
using Aoc22.Helpers

export day8

function parse_input(filename::String)
    lines = readlines(filename)
    
    n, m = length(lines), length(lines[1])
    H = Matrix{Int8}(undef,n,m)
    for i in 1:n
        line = lines[i]
        for j in 1:m 
            H[i,j] = parse(Int8,line[j])
        end
    end
    return H
end

function is_visible(::Up,H::Matrix{Int8},I::CartesianIndex) :: Bool
    return all(H[I] .> H[1:I[1]-1,I[2]])
end

function is_visible(::Down,H::Matrix{Int8},I::CartesianIndex) :: Bool
    return all(H[I] .> H[I[1]+1:end,I[2]])
end

function is_visible(::Left,H::Matrix{Int8},I::CartesianIndex) :: Bool
    return all(H[I] .> H[I[1],1:I[2]-1])
end

function is_visible(::Right,H::Matrix{Int8},I::CartesianIndex) :: Bool
    return all(H[I] .> H[I[1],I[2]+1:end])
end

function is_visible(H::Matrix{Int8},I::CartesianIndex) :: Bool
    return is_visible(Up(),H,I) || is_visible(Down(),H,I) || is_visible(Left(),H,I) || is_visible(Right(),H,I)
end

function viewing_distance(::Up,H::Matrix{Int8},I::CartesianIndex) :: Int
    n,m = size(H)
    (I[1] == 1) && (return 0)

    d = 1
    while (I[1]-d >= 1) && (H[I[1]-d,I[2]] < H[I])
        d += 1
    end
    (I[1]-d < 1) && (d -= 1)

    return d
end

function viewing_distance(::Down,H::Matrix{Int8},I::CartesianIndex) :: Int
    n,m = size(H)
    (I[1] == n) && (return 0)

    d = 1
    while (I[1]+d <= n) && (H[I[1]+d,I[2]] < H[I])
        d += 1
    end
    (I[1]+d > n) && (d -= 1)

    return d
end

function viewing_distance(::Left,H::Matrix{Int8},I::CartesianIndex) :: Int
    n,m = size(H)
    (I[2] == 1) && (return 0)

    d = 1
    while (I[2]-d >= 1) && (H[I[1],I[2]-d] < H[I])
        d += 1
    end
    (I[2]-d < 1) && (d -= 1)

    return d
end

function viewing_distance(::Right,H::Matrix{Int8},I::CartesianIndex) :: Int
    n,m = size(H)
    (I[2] == m) && (return 0)

    d = 1
    while (I[2]+d <= m) && (H[I[1],I[2]+d] < H[I])
        d += 1
    end
    (I[2]+d > m) && (d -= 1)

    return d
end

function scenic_score(H::Matrix{Int8},I::CartesianIndex)
    vd = map(D -> viewing_distance(D,H,I), [Up(),Down(),Left(),Right()])
    return prod(vd)
end

function day8()
    filename = "data/day8.txt"
    H = parse_input(filename)

    num_vis = count(I -> is_visible(H,I),CartesianIndices(size(H)))
    scores = map(I -> scenic_score(H,I),CartesianIndices(size(H)))

    return num_vis, maximum(scores)
end

end