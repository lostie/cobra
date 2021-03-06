module PairingStrategies
  class Swiss < Base
    BYE_WINNER_SCORE = 6
    BYE_LOSER_SCORE = 0

    def pair!
      assign_byes!

      Swissper.pair(
        (players - players_with_byes).to_a,
        delta_key: :points,
        exclude_key: :unpairable_opponents
      ).each do |pairing|
        round.pairings.create(pairing_params(pairing))
      end

      apply_numbers!(PairingSorters::Ranked)
    end

    private

    def assign_byes!
      players_with_byes.each do |player|
        round.pairings.create(
          player1: player,
          player2: nil,
          score1: BYE_WINNER_SCORE,
          score2: BYE_LOSER_SCORE
        )
      end
    end

    def pairing_params(pairing)
      {
        player1: player_from_pairing(pairing[0]),
        player2: player_from_pairing(pairing[1]),
        score1: auto_score(pairing, 0),
        score2: auto_score(pairing, 1)
      }
    end

    def player_from_pairing(player)
      player == Swissper::Bye ? nil : player
    end

    def auto_score(pairing, player_index)
      return unless pairing[0] == Swissper::Bye || pairing[1] == Swissper::Bye

      pairing[player_index] == Swissper::Bye ? BYE_LOSER_SCORE : BYE_WINNER_SCORE
    end

    def apply_numbers!(sorter)
      sorter.sort(round.pairings).each_with_index do |pairing, i|
        pairing.update(table_number: i + 1)
      end
    end

    def players_with_byes
      return players.with_first_round_bye if (stage.rounds - [round]).empty?

      []
    end
  end
end
