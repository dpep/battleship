#!/usr/bin/env ruby

require 'set'
require './board'
require './player'
require './game'
require './ship'


# grid of 10x10
# 5 ships:
#   Carrier (occupies 5 spaces),
#   Battleship (4), Cruiser (3), Submarine (3), and Destroyer (2)


# TODOs:
#   - rehitting a ship

def clear = system('clear')

ships = [
  Ship.new('Carrier', 'C', 5),
  Ship.new('Battleship', 'B', 4),
  Ship.new('Cruiser', 'c', 3),
  Ship.new('Submarine', 'S', 3),
  Ship.new('Destroyer', 'D', 2)
]


puts 'Welcome to Battleship!'
puts
sleep 1
puts 'Get to your battle stations!'
sleep 1


players = []
players << BotPlayer.new
players << BotPlayer.new
# players << HumanPlayer.new

game = Game.new(ships, players)
game.setup!
players = game.players

Signal.trap("INT") do
  clear
  puts game.to_s
  puts
  exit
end


# play game
until game.done?
  # render boards
  clear

  puts "#{players.first.name}, it's your turn!"
  puts
  puts game.to_s(players.first)
  puts

  # player makes move
  move = players.first.next_move
  puts "firing at (#{move.join(', ')})"
  res = players.last.board.fire!(*move)

  # annouce results
  if res.is_a?(Ship)
    if res.sunk?
      puts "You sunk their #{res.name}!"
    else
      puts "hit!"
    end
  end

  players.rotate!

  # slow down bots
  # if players.all? { |p| p.is_a?(BotPlayer) }
  #   sleep 0.1
  # end
end


# show final results
clear
winner = game.winner
puts "#{winner.name} wins!"
puts
puts game.to_s
puts
