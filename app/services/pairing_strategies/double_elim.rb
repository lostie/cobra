module PairingStrategies
  class DoubleElim < Base
    def pair!
      bracket.new(tournament).pair(round.number).each do |pairing|
        round.pairings.create(
          player1: pairing[:player1],
          player2: pairing[:player2],
          table_number: pairing[:table_number],
          side: SideDeterminer.determine_sides(pairing[:player1], pairing[:player2])
        )
      end
    end

    private

    def bracket
      Bracket::Factory.bracket_for tournament.players.count
    end
  end
end
