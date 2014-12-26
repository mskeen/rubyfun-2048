require 'spec_helper'
require 'board'

describe Board do

  describe "grid" do
    let(:board) { Board.new(3,2) }

    it 'has a width and height' do
      expect(board.width).to eq 3
      expect(board.height).to eq 2
    end

    it 'allows placement of a Tile' do
      value = 2
      board.location(1, 2).value = value
      expect(board.location(1,2).value).to eq value
    end

    it 'returns EmptyTile for an empty slot' do
      expect(board.location(1,2)).to be_empty
    end

    it 'won''t allow placement outsite the bounds' do
      expect { board.location(0, 1).value = 2 }.to raise_error
      expect { board.location(9, 1).value = 2 }.to raise_error
      expect { board.location(1, 0).value = 2 }.to raise_error
      expect { board.location(1, 9).value = 2 }.to raise_error
    end
  end

  describe "tilt" do
    let(:board) { Board.new }
    before(:each) { board.location(2, 3).value = 2 }

    it "throws exception with invalid direction" do
      expect { board.tilt(:diagonal) }.to raise_error('InvalidDirection')
    end

    it "moves tiles to the left" do
      board.tilt(:left)
      expect(board.location(1, 3).value).to eq 2
      expect(board.location(2, 3).value).to eq 0
    end

    it "moves tiles to the right" do
      board.tilt(:right)
      expect(board.location(4, 3).value).to eq 2
      expect(board.location(2, 3).value).to eq 0
    end
    it "moves tiles up" do
      board.tilt(:up)
      expect(board.location(2, 1).value).to eq 2
      expect(board.location(2, 3).value).to eq 0
    end
    it "moves tiles down" do
      board.tilt(:down)
      expect(board.location(2, 4).value).to eq 2
      expect(board.location(2, 3).value).to eq 0
    end
  end
end
