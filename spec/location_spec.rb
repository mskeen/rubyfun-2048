require 'spec_helper'
require 'board'

describe Location do
  let(:board) { Board.new(4,4) }

  describe :empty? do
    it 'is true when created' do
      expect(board.location(1,1)).to be_empty
    end

    it 'is false when valued' do
      board.location(1,1).value = 2
      expect(board.location(1,1)).to_not be_empty
    end
  end

  describe :neighbour do
    it 'returns the adjacent location' do
      expect(board.location(2,1).neighbour(:left)).to eq board.location(1,1)
      expect(board.location(2,1).neighbour(:right)).to eq board.location(3,1)
      expect(board.location(2,2).neighbour(:up)).to eq board.location(2,1)
      expect(board.location(2,1).neighbour(:down)).to eq board.location(2,2)
    end

    it 'is nil when off the board' do
      expect(board.location(2,1).neighbour(:up)).to be_nil
      expect(board.location(1,2).neighbour(:left)).to be_nil
      expect(board.location(3,4).neighbour(:down)).to be_nil
      expect(board.location(4,3).neighbour(:right)).to be_nil
    end
  end

  describe :can_merge? do
    it 'is true if the neighbour has the same non-empty value' do
      board.location(2,2).value = 2
      board.location(2,3).value = 2
      expect(board.location(2,2).can_merge?(:down)).to eq true
    end

    it 'is false if the location is empty' do
      expect(board.location(2,2).can_merge?(:down)).to eq false
    end

    it 'is false if the neighbour is empty' do
      board.location(2,2).value = 2
      expect(board.location(2,2).can_merge?(:down)).to eq false
    end
  end

  describe :can_move? do
    it 'is true if there is an empty space in the neighbour location' do
      board.location(2,2).value = 2
      expect(board.location(2,2).can_move?(:down)).to eq true
      expect(board.location(2,2).can_move?(:up)).to eq true
      expect(board.location(2,2).can_move?(:left)).to eq true
      expect(board.location(2,2).can_move?(:right)).to eq true
    end

    it 'is false if already on the border' do
      board.location(1,1).value = 2
      board.location(4,4).value = 2
      expect(board.location(1,1).can_move?(:left)).to eq false
      expect(board.location(1,1).can_move?(:up)).to eq false
      expect(board.location(4,4).can_move?(:down)).to eq false
      expect(board.location(4,4).can_move?(:right)).to eq false
    end

    it 'is false if location is empty' do
      expect(board.location(1,1).can_move?(:right)).to eq false
    end

    it 'is true when non-adjacent locations are empty' do
      board.location(1,2).value = 2
      board.location(2,2).value = 2
      board.location(3,2).value = 2
      expect(board.location(1,2).can_move?(:right)).to eq true
    end
  end

end
