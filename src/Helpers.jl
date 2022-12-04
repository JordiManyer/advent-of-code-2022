module Helpers

export split_vector

function split_vector(data::Vector{T},marker::T) where T
    ptrs = [0,findall(x->x==marker,data)...,length(data)+1]
    N = length(ptrs)
    res = Vector{Vector{Int}}(undef,N-1)
    for k in 1:N-1
        res[k] = data[ptrs[k]+1:ptrs[k+1]-1]
    end
    return res
end

end