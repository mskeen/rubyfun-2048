require 'spec_helper'

describe Tile do
  it 'returns the initialized value' do
    expect(Tile.new(2).value).to eq 2
  end
end

describe EmptyTile do
  it 'returns a value of 0' do
    expect(EmptyTile.new.value).to eq 0
  end
end
