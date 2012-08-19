describe 'Tictactoe.Views.Game', ->
  game = null

  beforeEach ->
    loadFixtures 'game_view'
    game = new Tictactoe.Views.Game

  it 'fills the board with 9 fields', ->
    expect($('.field').length).toEqual 9

  describe 'plays the game to its end', ->
    beforeEach ->
      # just clicks randomly till you finish the game
      while $('.game.in-progress').length > 0
        $('.field.empty').click()

    it 'show footer, status, and new-game button', ->
      expect($('footer')).toBeVisible()
      expect($('.status')).not.toHaveText ""
      expect($('.new-game')).toBeVisible()

    it 'starts new game', ->
      $('.new-game').click()
      expect($('.game')).toHaveClass 'in-progress'
      expect($('.field.empty')).toExist()
