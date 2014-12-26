class Location
  attr_reader :col, :row
  attr_accessor :value

  def initialize(col, row, value = 0)
    @col = col
    @row = row
    @value = value
    @merged_this_turn = false
  end

  def empty?
    self.value == 0
  end

  def merge(loc)
    if can_merge?(loc)
      @merged_this_turn = true if self.value == loc.value
      self.value += loc.value
      loc.value = 0
      return true
    end
    false
  end

  def reset_for_next_turn
    @merged_this_turn = false
  end

  protected

  def merged_this_turn?
    @merged_this_turn
  end

  private

  def can_merge?(loc)
    (empty? && !loc.empty? || (value == loc.value && !empty?)) &&
      !(merged_this_turn? || loc.merged_this_turn?)
  end

end
