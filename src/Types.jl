module Types

export Direction
export Up, Down, Left, Right
export Movement, move

abstract type Direction end
struct Up <: Direction end
struct Down <: Direction end
struct Left <: Direction end
struct Right <: Direction end

const Movement = Tuple{Direction,Int}


move(::Up,pos::CartesianIndex{2},n::Integer)    = CartesianIndex(pos[1]+n , pos[2]  )
move(::Down,pos::CartesianIndex{2},n::Integer)  = CartesianIndex(pos[1]-n , pos[2]  )
move(::Left,pos::CartesianIndex{2},n::Integer)  = CartesianIndex(pos[1]   , pos[2]-n)
move(::Right,pos::CartesianIndex{2},n::Integer) = CartesianIndex(pos[1]   , pos[2]+n)

move(d::Direction,pos::CartesianIndex{2}) = move(d,pos,1)
move(m::Movement,pos::CartesianIndex{2}) = move(m[1],pos,m[2])

move(::Up,pos::NTuple{2},n::Integer)    = (pos[1]+n , pos[2]  )
move(::Down,pos::NTuple{2},n::Integer)  = (pos[1]-n , pos[2]  )
move(::Left,pos::NTuple{2},n::Integer)  = (pos[1]   , pos[2]-n)
move(::Right,pos::NTuple{2},n::Integer) = (pos[1]   , pos[2]+n)

move(d::Direction,pos::NTuple{2}) = move(d,pos,1)
move(m::Movement,pos::NTuple{2}) = move(m[1],pos,m[2])

end