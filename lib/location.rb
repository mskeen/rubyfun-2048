class Location
  attr_reader :col, :row, :state
  attr_accessor :value

  STATE_RESTING = 0
  STATE_MERGING = 1
  STATE_MERGED  = 2

  EMPTY_VALUE = 0
  DIRECTIONS = {
    up:    { reverse: false, delta_col:  0,  delta_row: -1 },
    down:  { reverse: true,  delta_col:  0,  delta_row:  1 },
    left:  { reverse: false, delta_col: -1,  delta_row:  0 },
    right: { reverse: true,  delta_col:  1,  delta_row:  0 }
  }


  def initialize(board, col, row, value = EMPTY_VALUE)
    @board = board
    @col = col
    @row = row
    @value = value
    @state = STATE_RESTING
  end

  def empty?
    self.value == EMPTY_VALUE
  end

  def neighbour(direction)
    dir = DIRECTIONS[direction]
    board.location(col + dir[:delta_col], row + dir[:delta_row])
  end

  def can_move?(direction)
    return false if empty?
    loc = self
    while (loc = loc.neighbour(direction)) do
      return true if loc.empty? || loc.can_merge?(direction)
    end
    false
  end

  def can_merge?(direction)
    to_loc = neighbour(direction)
    !self.empty? && to_loc && self.value == to_loc.value &&
      !(self.already_merged? || to_loc.already_merged?)
  end

  def move(direction)
    return false unless can_move?(direction)
    neighbour(direction).value, self.value = self.value, EMPTY_VALUE
    true
  end

  def merge(direction)
    return false unless can_merge?(direction)
    new_loc = neighbour(direction)
    new_loc.value += self.value
    new_loc.merging!
    self.value = EMPTY_VALUE
    true
  end

  def reset_for_next_turn
    @state = STATE_RESTING
  end

  def merging!
    @state = STATE_MERGING
  end

  def merged!
    @state = STATE_MERGED
  end

  def merging?
    state == STATE_MERGING
  end

  def merged?
    state == STATE_MERGED
  end

  protected

  def already_merged?
    merging? || merged?
  end

  private

  def board
    @board
  end

end
