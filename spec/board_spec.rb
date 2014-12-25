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
      board.place_at(1, 2, Tile.new(value))
      expect(board.tile_at(1,2).value).to eq value
    end

    it 'returns EmptyTile for an empty slot' do
      expect(board.tile_at(1,2).class).to eq EmptyTile
    end

    it 'won''t allow placement outsite the bounds' do
      tile = Tile.new(2)
      expect { board.place_at(0, 1, tile) }.to raise_error('InvalidLocation')
      expect { board.place_at(9, 1, tile) }.to raise_error('InvalidLocation')
      expect { board.place_at(1, 0, tile) }.to raise_error('InvalidLocation')
      expect { board.place_at(1, 9, tile) }.to raise_error('InvalidLocation')
    end
  end

  describe "tilt" do
    let(:board) { Board.new }
    before(:each) { board.place_at(2, 3, Tile.new(2)) }

    it "throws exception with invalid direction" do
      expect { board.tilt(:diagonal) }.to raise_error('InvalidDirection')
    end

    it "moves tiles to the left" do
      board.tilt(:left)
      expect(board.tile_at(1, 3).value).to eq 2
      expect(board.tile_at(2, 3).value).to eq 0
    end

    it "moves tiles to the right" do
      board.tilt(:right)
      expect(board.tile_at(4, 3).value).to eq 2
      expect(board.tile_at(2, 3).value).to eq 0
    end
    it "moves tiles up" do
      board.tilt(:up)
      expect(board.tile_at(2, 1).value).to eq 2
      expect(board.tile_at(2, 3).value).to eq 0
    end
    it "moves tiles down" do
      board.tilt(:down)
      expect(board.tile_at(2, 4).value).to eq 2
      expect(board.tile_at(2, 3).value).to eq 0
    end
  end
end
