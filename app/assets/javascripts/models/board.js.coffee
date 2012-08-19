class Tictactoe.Models.Board
  checks: [
   [0,1,2], [3,4,5], [6,7,8],
   [0,3,6], [1,4,7], [2,5,8],
   [0,4,8], [2,4,6]
  ]

  constructor: ->
    @pins = []
    @pins[8] = undefined

  setPin: (pin, index) ->
    if !@getPin(index)
      @pins[index] = pin
      true
    else
      false

  getPin: (index) ->
    @pins[index]

  isGameOver: ->
    !!@winner() || @emptyFields().length == 0

  winner: ->
    report = @analyzeBoard()
    return 'x' if report.x.victory
    return 'o' if report.o.victory
    false

  winningPins: ->
    return null unless @winner()
    @analyzeBoard()[@winner()].pins

  nextMove: (player) ->
    return null if @winner()
    report = @analyzeBoard()

    opportunities = report[player].opportunities
    if opportunities.length == 0
      opportunities = report[@oppositePlayer(player)].opportunities

    if opportunities.length > 0
      @choice opportunities
    else
      @choice @emptyFields()

  emptyFields: ->
    index for pin, index in @pins when !pin

  choice: (arr) ->
    index = Math.round(Math.random() * (arr.length - 1))
    arr[index]

  randomPlayer: ->
    @choice ['x', 'o']

  oppositePlayer: (player) ->
    if player == 'x' then 'o' else 'x'

  analyzeBoard: (player) ->
    report = {
      x: new Tictactoe.Models.BoardPlayerReport(),
      o: new Tictactoe.Models.BoardPlayerReport(),
    }

    for pins in @checks
      hits = 0
      opportunity = null

      for index in pins
        switch @getPin(index)
          when 'x' then hits += 1
          when 'o' then hits -= 1
          else opportunity = index

      player = if (hits > 0) then 'x' else 'o'

      if Math.abs(hits) == 3
        report[player].victory = true
        report[player].pins = pins

      else if Math.abs(hits) == 2 && opportunity
        report[player].opportunities.push opportunity

    report


class Tictactoe.Models.BoardPlayerReport
  constructor: ->
    @victory = false
    @opportunities = []
