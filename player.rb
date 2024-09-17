class Player
  attr_reader :name, :board

  def initialize(name)
    @name = name
    @board = Board.new
  end

  def setup_board(ships)
    raise NotImplementedError
  end

  def next_move
    raise NotImplementedError
  end

  def done?
    board.done?
  end
end


class BotPlayer < Player
  def initialize
    @@count ||= 0
    @@count += 1
    super("Bot #{@@count}")

    @moves = Set.new
  end


  def setup_board(ships)
    board.generate_board(ships)
  end


  def next_move
    x, y = nil, nil
    loop do
      x, y = rand(board.size), rand(board.size)
      next if @moves.include?([x, y])

      @moves << [x, y]
      break
    end

    [x, y]
  end
end

class HumanPlayer < Player
  def initialize
    puts "Please enter your name:"

    name = gets.chomp
    if name.empty?
      name = ENV['USER'] || 'Player'
    end

    super(name)
  end

  def setup_board(ships)
    puts "Let's set up your board!"

    puts "Do you want to place your ships manually? (y/[n])"
    unless gets.chomp.downcase[0] == 'y'
      board.generate_board(ships)
      return
    end

    puts "Your board is 10x10.  Ships are placed horizontally or vertically."
    puts "Please enter the coordinates for each ship and h/v, eg:  1, 2, h"
    puts
    ships.each do |ship|
      puts "Where do you want to put your #{ship.name}  (size: #{ship.size})?"
      x, y, orientation = get_ship_coordinates
      board.place_ship(ship, x, y, orientation)
    rescue ArgumentError
      puts "whoops, wrong coordinates"
      retry
    end
  end

  def next_move
    puts "Please enter your next move (x, y):"
    gets.chomp.split(/[^\d]/).map(&:to_i)
  end

  private

  def get_ship_coordinates
    x, y, orientation = gets.chomp.split(/[,\s]/)

    orientation = case orientation.downcase[0]
    when 'h'
      :horizontal
    when 'v'
      :vertical
    else
      raise ArgumentError, "invalid orientation: #{orientation}"
    end

    [ x.to_i, y.to_i, orientation ]
  end
end
