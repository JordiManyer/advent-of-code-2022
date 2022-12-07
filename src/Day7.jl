module Day7

using AbstractTrees
using Aoc22.Helpers

export day7


struct File
    name::String
    size::Int
end

size(f::File)::Int = f.size
AbstractTrees.printnode(io::IO, f::File) = print(io, f.name)

mutable struct Directory
    name   :: String
    parent :: Union{Directory,Nothing}
    files  :: Vector{File}
    dirs   :: Vector{Directory}
    size   :: Int 
end

function Directory(name::String,parent::Directory)
    return Directory(name,parent,File[],Directory[],-1)
end

function RootDir()
    return Directory("/",nothing,File[],Directory[],-1)
end

AbstractTrees.children(dir::Directory) = dir.dirs
AbstractTrees.parent(dir::Directory) = dir.parent
AbstractTrees.printnode(io::IO, dir::Directory) = print(io, dir.name)


function size(dir::Directory)
    if dir.size != -1
        return dir.size
    else
        s = 0
        length(dir.files) != 0 && (s += sum(map(size,dir.files)))
        length(dir.dirs) != 0 && (s += sum(map(size,dir.dirs)))
        dir.size = s
        return dir.size
    end
end

add_file!(dir::Directory,f::File) = push!(dir.files,f)
add_dir!(dir::Directory,subdir::Directory) = push!(dir.dirs,subdir)

abstract type Command end
struct CD <: Command
    dir::String
end
struct LS <: Command end

is_command(line::String) = (line[1] == '$')

function cd(pwd::Directory,cmd::CD)
    if cmd.dir == ".."
        return AbstractTrees.parent(pwd)
    else
        subdirs = AbstractTrees.children(pwd)
        id = findfirst(d -> d.name==cmd.dir,subdirs)
        @assert id !== nothing
        return subdirs[id]
    end
end

function parse_command(line::String)
    @assert is_command(line)
    v = split(line,' ')
    if v[2] == "ls"
        return LS()
    else
        return CD(v[3])
    end
end

function parse_content!(line::String,pwd::Directory)
    @assert !is_command(line)
    v = split(line,' ')
    if v[1] == "dir"
        dir = Directory(string(v[2]),pwd)
        add_dir!(pwd,dir)
        return dir
    else
        f = File(string(v[2]),parse(Int,v[1]))
        add_file!(pwd,f)
        return f
    end
end

function parse_input(filename::String)
    lines = readlines(filename)

    N = length(lines)
    root = RootDir()

    k = 1; pwd = root
    while (k <= N)
        cmd = parse_command(lines[k])
        k += 1
        if isa(cmd,CD)
            pwd = cd(pwd,cmd)
        else
            while (k <= N) && !is_command(lines[k])
                parse_content!(lines[k],pwd)
                k += 1
            end
        end
    end
    return root
end

function day7()
    filename = "data/day7.txt"
    root = parse_input(filename)
    
    sizes = map(size,PreOrderDFS(root))
    free = 70000000 - size(root)
    target = 30000000

    res1 = sum(filter(s -> s <= 100000,sizes))
    res2 = minimum(filter(s -> free+s >= target,sizes))

    return res1, res2
end

end