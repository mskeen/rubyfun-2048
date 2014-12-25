require 'spec_helper'

describe Board do
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
