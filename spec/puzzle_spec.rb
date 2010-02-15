require File.join(File.dirname(__FILE__), '..', 'puzzle.rb')

describe 'A default Puzzle' do

  before :each do
    @puzzle = Puzzle.new
  end

  it 'should have dimension of three' do
    @puzzle.tiles.size.should == 3
  end

  it 'should be solved' do
    @puzzle.solved?.should be_true
  end

  it 'should be cloneable' do
    p2 = @puzzle.clone
    @puzzle.move(2,1)
    p2.tiles.should_not == @puzzle.tiles
  end

  it 'should have the hole at 2,2' do
    @puzzle.hole.should == [2,2]
  end

  it 'should allow valid moves' do
    lambda {@puzzle.move(2,1)}.should_not raise_error
  end

  it 'should not allow invalid moves' do
    lambda {@puzzle.move(1,1)}.should raise_error Puzzle::InvalidMove
  end

  it 'should list available moves' do
    @puzzle.available_moves.should == [[1, 2], [2, 1]]
  end

  it 'should swap hole and tile after move' do
    @puzzle.move(2,1)
    @puzzle.hole.should == [2,1]
  end

  it 'should shuffle' do
    @puzzle.shuffle(3)
    @puzzle.should_not be_solved
  end

end

describe 'A 16 tile Puzzle' do

  before :each do
    @puzzle = Puzzle.new(4)
  end

  it 'should accept dimension argument of 4' do
    @puzzle.tiles.size.should == 4
  end

  it 'should be solved' do
    @puzzle.should be_solved
  end

  it 'should have the hole at 3,3' do
    @puzzle.hole.should == [3,3]
  end

  it 'should allow valid moves' do
    lambda {@puzzle.move(3,2)}.should_not raise_error
  end

  it 'should not allow invalid moves' do
    lambda {@puzzle.move(1,1)}.should raise_error Puzzle::InvalidMove
  end

  it 'should list available moves' do
    @puzzle.available_moves.should == [[2, 3], [3, 2]]
  end

  it 'should swap hole and tile after move' do
    @puzzle.move(3,2)
    @puzzle.hole.should == [3,2]
  end

  it 'should shuffle' do
    @puzzle.shuffle(3)
    @puzzle.should_not be_solved
  end

end

describe 'A specified Puzzle' do

  before :each do
    @puzzle = Puzzle.new([[1, 2], [3, nil]])
  end

  it 'should accept a 2 dimension array' do
    @puzzle.tiles.size.should == 2
  end

  it 'should detect a solved puzzle' do
    @puzzle.should be_solved
  end

  it 'should detect an unsolved puzzle' do
    @puzzle = Puzzle.new([[nil, 1], [3, 2]])
    @puzzle.should_not be_solved
  end

  it 'should detect the hole' do
    @puzzle.hole.should == [1,1]
  end

  it 'should have the hole at 1,1' do
    @puzzle.hole.should == [1,1]
  end

  it 'should allow valid moves' do
    lambda {@puzzle.move(1,0)}.should_not raise_error
  end

  it 'should not allow invalid moves' do
    lambda {@puzzle.move(0,0)}.should raise_error Puzzle::InvalidMove
  end

  it 'should list available moves' do
    @puzzle.available_moves.should == [[0, 1], [1, 0]]
  end

  it 'should swap hole and tile after move' do
    @puzzle.move(1,0)
    @puzzle.hole.should == [1,0]
  end

end
