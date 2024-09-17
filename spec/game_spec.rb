describe Game do
  subject(:game) { described_class.new(ships, players) }

  let(:ships) { [ Ship.new('Scout', 'S', 1) ] }

  let(:players) { [ BotPlayer.new, BotPlayer.new ] }

  before do
    game.setup!
  end

  describe "#done?" do
    it { is_expected.to_not be_done }

    context "when all ships are sunk" do
      let(:ship) { game.players.first.board.ships.first }

      before { ship.hit!(0) }

      it "is done" do
        expect(ship).to be_sunk
        expect(game).to be_done
      end

      it "has a winner" do
        expect(game.winner).to eq(game.players.last)
      end
    end
  end
end
