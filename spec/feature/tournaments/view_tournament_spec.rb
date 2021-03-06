RSpec.describe 'viewing a tournament' do
  context 'with public tournament' do
    let(:tournament) { create(:tournament) }

    before do
      tournament.players << create(:player, name: 'Jack Player')
      tournament.players << create(:player, name: 'Jill Player')
      tournament.players << create(:player, active: false)

      sign_in tournament.user
      visit tournament_path(tournament)
    end

    it 'displays count' do
      expect(page.body).to include('2 active players (1 dropped)')
    end
  end

  context 'with private tournament' do
    let(:tournament) { create(:tournament, private: true) }

    context 'as owner' do
      before do
        tournament.players << create(:player, name: 'Jack Player')
        tournament.players << create(:player, name: 'Jill Player')
        tournament.players << create(:player, active: false)

        sign_in tournament.user
        visit tournament_path(tournament)
      end
    end

    context 'as non-owner' do
      before do
        visit tournament_path(tournament)
      end

      it 'redirects away' do
        expect(page.current_path).to eq(root_path)
        expect(page).to have_content("Sorry, you can't do that")
      end
    end
  end
end
