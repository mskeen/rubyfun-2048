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
    it "throws exception with invalid direction" do
      expect { Board.new.tilt(:diagonal) }.to raise_error('InvalidDirection')
    end

    describe "directional" do
      let(:board) { Board.new }
      before(:each) { board.location(2, 3).value = 2 }

      it "moves tiles left" do
        board.tilt(:left)
        expect(board.location(1, 3).value).to eq 2
        expect(board.location(2, 3).value).to eq 0
      end

      it "moves tiles right" do
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

      it "merges matching tiles" do
      end
    end

    describe "merge" do
      let(:board) { Board.new }
      before(:each) { board.location(2, 3).value = 2 }

      it "matches identical tiles" do
        board.location(2,4).value = 2
        board.tilt(:down)
        expect(board.location(2,4).value).to eq 4
      end

      it "doesn't match non-identical tiles" do
        board.location(2,4).value = 4
        board.tilt(:up)
        expect(board.location(2,1).value).to eq 2
      end

      it "matches the first 2 tiles when 3 are identical" do
        board.location(1,3).value = 2
        board.location(3,3).value = 2
        board.tilt(:left)
        expect(board.location(1,3).value).to eq 4
        expect(board.location(2,3).value).to eq 2
        expect(board.location(3,3).value).to eq 0
      end

      it "only merges a tile once in a single tilt" do
        board.location(1,3).value = 2
        board.location(3,3).value = 2
        board.location(4,3).value = 2
        board.tilt(:right)
        expect(board.location(4,3).value).to eq 4
        expect(board.location(3,3).value).to eq 4
        expect(board.location(2,3).value).to eq 0
      end

    end


  end
end
