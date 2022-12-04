module Day3

using Aoc22.Helpers

export day3

function split_line(line::String)
    n = length(line)
    @assert n%2 == 0
    return (line[1:n÷2],line[n÷2+1:n])
end

function parse_input(filename::String)
    lines = readlines(filename)
    return lines
end

function priority(c::Char)
    if 'a' <= c <= 'z'
        return Int(c - 'a' + 1)
    else
        return Int(c - 'A' + 27)
    end
end

function find_common(t::Tuple{String,String})
    s1, s2 = sort(collect(t[1])), sort(collect(t[2]))
    n1, n2 = length(s1), length(s2)
    k1, k2 = 1, 1
    while(k1 <= n1 && k2 <= n2)
        if (s1[k1] == s2[k2])
            return s1[k1]
        elseif (s1[k1] < s2[k2])
            k1 += 1
        else
            k2 += 1
        end
    end
    return 0
end

function find_common(t::Tuple{String,String,String})
    s1, s2, s3 = sort(collect(t[1])), sort(collect(t[2])), sort(collect(t[3]))
    n1, n2, n3 = length(s1), length(s2), length(s3)
    k1, k2, k3 = 1, 1, 1
    while(k1 <= n1 && k2 <= n2 && k3 <= n3)
        if (s1[k1] == s2[k2] == s3[k3])
            return s1[k1]
        elseif (s1[k1] < s2[k2])
            k1 += 1
        elseif (s2[k2] < s3[k3])
            k2 += 1
        else
            k3 += 1
        end
    end
    return 0
end

function day3()
    filename = "data/day3.txt"
    data = parse_input(filename)

    compartiments = map(split_line,data)
    items = map(find_common,compartiments)
    priorities1 = map(priority,items)

    n = length(data)
    badges = map(k->find_common((data[k],data[k+1],data[k+2])),1:3:n)
    priorities2 = map(priority,badges)
    return sum(priorities1), sum(priorities2)
end

end