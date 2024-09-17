class Game
  attr_reader :board, :players

  def initialize(ships, players)
    @ships = ships
    @players = players
  end

  def setup!
    players.each do |player|
      player.setup_board(@ships)
    end
  end

  def done?
    players.count(&:done?) >= players.count - 1
  end

  def winner
    left = players.reject(&:done?)

    raise "no winner yet" if left.size > 1

    left.first
  end

  def to_s(active_player = nil)
    boards = players.map do |player|
      width = player.board.size * 2
      name = " " * (width / 2 - player.name.length / 2) + player.name
      full_view = active_player.nil? || player == active_player

      [
        "%-#{width}s" % name,
        "",
      ] + player.board.to_s(full_view).split("\n")
    end

    boards[0].size.times.map do |j|
      boards.map { |b| b[j] }.join(' ' * 10)
    end.join("\n")
  end
end
