class Board
  attr_reader :size

  def initialize
    @ships = {}
    @size = 10
    @grid = Array.new(@size) { Array.new(@size) }
  end

  def [](x, y)
    @grid[y][x]
  end

  def ships
    @ships.keys
  end

  def place_ship(ship, x, y, orientation)
    # duplicate ship to avoid modifying original
    ship = ship.dup unless ship.frozen?

    # check whether placement is valid
    if orientation == :horizontal
      (0...ship.size).each do |i|
        raise ArgumentError unless can_place?(x + i, y)
      end
    else
      (0...ship.size).each do |i|
        raise ArgumentError unless can_place?(x, y + i)
      end
    end

    # place ship
    if orientation == :horizontal
      (0...ship.size).each do |i|
        self[x + i, y] = ship
      end
    else
      (0...ship.size).each do |i|
        self[x, y + i] = ship
      end
    end

    # record ship placement
    @ships[ship] = { x: x, y: y, orientation: orientation }
  end

  def generate_board(ships)
    ships.each do |ship|
      loop do
        x, y = rand(0..size), rand(0..size)
        orientation = [:horizontal, :vertical].sample
        place_ship(ship, x, y, orientation)
        break
      rescue ArgumentError
        retry
      end
    end
  end

  def fire!(x, y)
    ship = self[x, y]

    if ship.is_a?(Ship)
      pos = pos_on_ship(ship, x, y)
      ship.hit!(pos)

      ship
    else
      self[x, y] = :miss

      nil
    end
  end

  def done?
    ships.all?(&:sunk?)
  end

  def to_s(full = false)
    @grid.map.with_index do |row, y|
      row.map.with_index do |cell, x|
        case cell
        when nil
          '.'  # unknown
        when :miss
          '_'  # miss
        when Ship
          ship = cell

          if ship.sunk?
            ship.symbol
          else
            if ship.hit?(pos_on_ship(ship, x, y))
              'x'
            else
              full ? ship.symbol : '.'
            end
          end
        end
      end.join(' ')
    end.join("\n") + "\n"
  end

  private

  def []=(x, y, val)
    @grid[y][x] = val
  end

  def pos_on_ship(ship, x, y)
    info = @ships[ship]

    if info[:orientation] == :horizontal
      info[:x] - x
    else
      info[:y] - y
    end.abs
  end

  def can_place?(x, y)
    return false unless (0...@size).include?(x)
    return false unless (0...@size).include?(y)
    return false if self[x, y].is_a?(Ship)

    true
  end
end
