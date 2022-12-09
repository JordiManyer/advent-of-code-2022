module Helpers

export split_vector
export distance

function split_vector(data::Vector{T},marker::T) where T
    ptrs = [0,findall(x->x==marker,data)...,length(data)+1]
    N = length(ptrs)
    res = Vector{Vector{Int}}(undef,N-1)
    for k in 1:N-1
        res[k] = data[ptrs[k]+1:ptrs[k+1]-1]
    end
    return res
end

function distance(p1::Union{CartesianIndex{N},NTuple{N,Int}},p2::Union{CartesianIndex,NTuple{N,Int}}) :: Int where N
    s = 0
    for k in 1:N
        s += abs(p1[k]-p2[k])
    end
    return s
end

end