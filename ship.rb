class Ship
  attr_reader :name, :symbol, :size

  def initialize(name, symbol, size)
    @name = name
    @symbol = symbol
    @size = size
    @hits = [ false ] * size
  end

  def hit!(pos)
    raise FrozenError if frozen?
    raise ArgumentError unless (0...size).include?(pos)

    @hits[pos] = true
  end

  def hit?(pos = nil)
    if pos
      raise ArgumentError unless (0...size).include?(pos)

      @hits[pos]
    else
      @hits.any?
    end
  end

  def sunk?
    @hits.all?
  end

  def dup
    super.tap do |ship|
      ship.instance_variable_set(:@hits, @hits.dup)
    end
  end

  def to_s
    "#{@name} (#{@size}) hits: #{@hits.select(&:itself).count} / #{@size}"
  end
end
