describe Ship do
  let(:ship) { Ship.new('Submarine', 'S', 3) }

  describe '#hit!' do
    it 'hits the ship' do
      expect(ship.hit!(0)).to be true
    end

    it 'checks bounds' do
      expect {
        ship.hit!(ship.size)
      }.to raise_error(ArgumentError)
    end
  end

  describe '#hit?' do
    context 'when no position is given' do
      it { expect(ship.hit?).to be false }

      it 'detects hits' do
        ship.hit!(0)
        expect(ship.hit?).to be true
      end
    end

    context 'when a position is given' do
      it { expect(ship.hit?(0)).to be false }

      it 'detects hits' do
        ship.hit!(0)
        expect(ship.hit?(0)).to be true
        expect(ship.hit?(1)).to be false
      end
    end
  end

  describe '#sunk?' do
    it { expect(ship.sunk?).to be false }

    it 'detects sunk ships' do
      ship.size.times do |i|
        ship.hit!(i)
      end

      expect(ship.sunk?).to be true
    end

    it 'distinguishes hits from sunk' do
      ship.hit!(0)

      expect(ship.sunk?).to be false
    end
  end

  describe '#freeze' do
    subject { ship.frozen? }

    it { is_expected.to be false }

    it 'freezes the ship' do
      ship.freeze
      is_expected.to be true
    end

    it 'prevents hits' do
      ship.freeze

      expect {
        ship.hit!(0)
    }.to raise_error(FrozenError)
    end
  end
end
