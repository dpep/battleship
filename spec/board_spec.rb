describe Board do
  subject(:board) { described_class.new }

  let(:scout) { Ship.new('Scout', 's', 1) }
  let(:submarine) { Ship.new('Submarine', 'S', 3) }

  before do
    # disable duplication to make testing easier
    allow(scout).to receive(:dup).and_return(scout)
    allow(submarine).to receive(:dup).and_return(submarine)
  end

  it 'has a size' do
    expect(board.size).to be_a Integer
    expect(board.size).to be > 0
  end

  describe '#place_ship' do
    it 'places a ship on the board' do
      board.place_ship(scout, 0, 0, :horizontal)
      expect(board[0, 0]).to eq scout
    end

    it 'validates that placement is in bounds' do
      expect {
        board.place_ship(submarine, 0, -1, :horizontal)
      }.to raise_error(ArgumentError)

      expect {
        board.place_ship(submarine, 0, board.size - 1, :vertical)
      }.to raise_error(ArgumentError)
    end

    it 'does not allow ships to overlap' do
      board.place_ship(submarine, 0, 0, :horizontal)

      expect {
        board.place_ship(scout, 0, 0, :horizontal)
      }.to raise_error(ArgumentError)
    end
  end

  describe '#fire!' do
    before { board.place_ship(scout, 0, 0, :horizontal) }

    it 'returns a ship object if a ship is hit' do
      expect(board.fire!(0, 0)).to eq scout
    end

    it 'returns nil if a ship is not hit' do
      expect(board.fire!(1, 1)).to be nil
    end

    it 'marks a ship as hit if it was hit' do
      board.fire!(0, 0)

      expect(scout).to be_hit
      expect(scout).to be_sunk
    end
  end

  describe '#done?' do
    before { board.place_ship(scout, 0, 0, :horizontal) }

    it { is_expected.not_to be_done }

    it 'detects done boards' do
      board.fire!(0, 0)
      is_expected.to be_done
    end
  end

  describe '#ships' do
    it 'returns all ships on the board' do
      board.place_ship(scout, 0, 0, :horizontal)
      board.place_ship(submarine, 0, 1, :horizontal)

      expect(board.ships).to eq [scout, submarine]
    end
  end

  describe '#generate_board' do
    before { board.generate_board(ships) }

    let(:ships) { [scout, submarine] }

    it 'places ships on the board' do
      expect(board.ships).to eq ships
    end

    it 'places does not overlap ships' do
      count = Hash.new(0)

      board.size.times do |x|
        board.size.times do |y|
          ship = board[x, y]
          expect(ship).to be_a(Ship).or be nil

          if ship.is_a?(Ship)
            count[ship] += 1
          end
        end
      end

      ships.each do |ship|
        expect(count[ship]).to eq ship.size
      end
    end
  end
end
