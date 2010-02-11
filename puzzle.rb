
class Puzzle
  attr_reader :tiles
  attr_reader :hole

  class InvalidMove < Exception; end

  def self.clone(puzzle)
    new(puzzle.tiles)
  end

  ##
  ## Represent the puzzle as N arrays of N length while addressing
  ## individuals tiles by their x,y coordinates with 0,0 origin at
  ## the upper left tile. The missing tile is represented by nil.
  ##
  ## For a 3x3 puzzle:
  ## 
  ##   [ [ 1, 2, 3   ],
  ##     [ 4, 5, 6   ],
  ##     [ 7, 8, nil ] ]
  ##
  ## Addressing a position with x,y coordinates requires reversing
  ## the coordinates internally when using Ruby multi-dimensional
  ## array syntax.  In the above example, the "6" at position 2,1
  ## would be addressed as array[1][2].
  ##
  ## Accepts a single Fixnum representing the dimension of the 
  ## square grid (default 3) or a 2 dimension Array representing
  ## an existing state.
  ##
  def initialize(arg = 3)
    @tiles = arg.is_a?(Array) ? arg : generate_solved_array(arg)
    @hole  = find_hole
    @moves = 0
  end

  ##
  ## Return list of x,y coordinates for valid moves given the
  ## current state of the puzzle
  ##
  def available_moves
    adjacent_tiles(*@hole)
  end

  ##
  ## Pass the x,y coordinates of the tile to swap with the hole
  ##
  def move(dx, dy)
    unless adjacent_tiles(dx, dy).include?(@hole)
      raise InvalidMove, "#{dx},#{dy} -> #{@hole[0]},#{@hole[1]}"
    end
    @tiles[dy][dx], @tiles[@hole[1]][@hole[0]] = @tiles[@hole[1]][@hole[0]], @tiles[dy][dx]
    @hole = [dx, dy]
    @moves += 1
  end

  def solved?
    @tiles == generate_solved_array(@tiles.size)
  end
  
  ##
  ## Shuffle the puzzle.  Necessary since there are unsolvable
  ## configurations of the tiles
  ##
  def shuffle(iterations = 5000)
    iterations.times do
      moves = available_moves
      move(*moves[rand(moves.size)])
    end
    @moves = 0
  end

protected

  ## create a solved puzzle with dim^2 tiles
  def generate_solved_array(dim)
    tiles = dim.times.map {|i| dim.times.map {|j| (j+1)+dim*(i)}}
    tiles[dim-1][dim-1] = nil
    tiles
  end  

  ## returns list of coordinates representing adjacent tiles
  def adjacent_tiles(dx, dy)
    tiles = []
    @tiles.size.times do |x|
      @tiles.size.times do |y|
        if ((x+1 == dx || x-1 == dx) && y == dy) || 
           ((y+1 == dy || y-1 == dy) && x == dx)
          tiles << [x, y]
        end
      end
    end
    tiles
  end

  ## returns the x,y coordinates of the hole as an array
  def find_hole
    @tiles.size.times do |x|
      @tiles.size.times do |y|
        return [x,y] if @tiles[y][x].nil?
      end
    end
  end

end
