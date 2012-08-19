class Tictactoe.Models.Game extends Backbone.Model
  url: '/games'
  firstPlayer: 'x'

  initialize: ->
    @board = new Tictactoe.Models.Board()

  start: ->
    @set 'player', @board.randomPlayer()
    if @get('player') != @firstPlayer
      @cpuSetPin()

  getCpuPlayer: ->
    @board.oppositePlayer @get('player')

  cpuSetPin: ->
    index2 = @board.nextMove(@getCpuPlayer())
    @board.setPin(@getCpuPlayer(), index2)
    @trigger('change')

  setPin: (index) ->
    return false if @board.isGameOver()

    success = @board.setPin(@get('player'), index)
    return false unless success
    @trigger('change')

    @cpuSetPin()
    @checkStatus()

  checkStatus: ->
    if @board.isGameOver()
      pins = null
      if winner = @board.winner()
        @set 'victory', (winner == @get('player'))
        pins = @board.winningPins()
      @trigger('over', pins)

