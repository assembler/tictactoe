class Tictactoe.Views.Game extends Backbone.View
  el: '#tictactoe-game'
  template: JST['games/game']

  events:
    'click .field': 'setPin'
    'click .new-game': 'newGame'

  initialize: ->
    @render()
    @newGame()

  newGame: ->
    @game = new Tictactoe.Models.Game
    @game.start()

    @game.bind 'change', @refreshBoard, this
    @game.bind 'over',   @gameOver,     this
    @game.bind 'sync',   @refreshStats, this

    @clearBoard()
    @refreshBoard()

  render: ->
    @$el.html @template()

    @$board = $('.board')
    @statsView = new Tictactoe.Views.Stats el: $('.stats')

    if @game?
      @clearBoard()
      @refreshBoard()

    this

  clearBoard: ->
    @$el.addClass 'in-progress'
    @$board.empty()

    for pin, index in @game.board.pins
      $li = $('<li>', class: "field empty", 'data-index': index )
      @$board.append $li

  refreshBoard: ->
    for pin, index in @game.board.pins
      $li = $(".field[data-index=#{index}]")
      if pin
        $li.addClass("player-#{pin}")
        $li.text(pin)

  refreshStats: ->
    @statsView.refresh()

  setPin: (event) ->
    index = $(event.target).data('index')
    @game.setPin index

  gameOver: (pins) ->
    if @game.get('victory') is undefined
      status = "It's a draw."
      klass = 'draw'
    else
      if @game.get('victory')
        status = "Congrats, you win!"
        klass = 'victory'
      else
        status = "Sorry, you lose!"
        klass = 'defeat'
      for index in pins
        $(".field[data-index=#{index}]", @$board).addClass('win')

    $('.status').text status
    $('.status').addClass klass

    @$el.removeClass('in-progress')
    @game.save()
