describe 'Tictactoe.Models.Board', ->
  board = null

  beforeEach ->
    board = new Tictactoe.Models.Board

  describe '#setPin(pin, index)', ->
    it 'sets pin on given index and returns true', ->
      expect(board.setPin('x', 0)).toBe true
      expect(board.getPin(0)).toEqual 'x'

    it 'rejects operation and returns false if field is taken', ->
      board.setPin('x', 0)
      expect(board.setPin('o', 0)).toBe false
      expect(board.getPin(0)).toEqual 'x'

  describe '#emptyFields()', ->
    it 'returns indexes for empty fields on board', ->
      board.pins = ['x', 'x', 'x', null, 'x', null, 'o', 'o', null]
      expect(board.emptyFields()).toEqual [3,5,8]

  describe '#choice(arr)', ->
    it 'returns random element from the array', ->
      arr = [3,5,7]
      spyOn(Math, 'random').andReturn 0.4
      expect(board.choice(arr)).toEqual 5 # Math.round(0.4 * 2)

  describe '#isGameOver()', ->
    it 'returns true if the game has winner', ->
      spyOn(board, 'winner').andReturn 'x'
      expect(board.isGameOver()).toBe true

    it 'returns true if there are no empty fields', ->
      spyOn(board, 'emptyFields').andReturn []
      expect(board.isGameOver()).toBe true

    it 'returns false if there is no winner and there are empty fields', ->
      spyOn(board, 'winner').andReturn null
      spyOn(board, 'emptyFields').andReturn [1]
      expect(board.isGameOver()).toBe false

  describe '#randomPlayer', ->
    it 'returns the random player', ->
      spyOn(board, 'choice').andReturn 'x'
      expect(board.randomPlayer()).toEqual 'x'

  describe '#oppositePlayer(player)', ->
    it 'returns the opposite player', ->
      expect(board.oppositePlayer('x')).toEqual 'o'
      expect(board.oppositePlayer('o')).toEqual 'x'

  describe '#analyzeBoard', ->
    describe 'fields empty', ->
      it 'returns nothing', ->
        report = board.analyzeBoard()
        expect(report.x.victory).toBe false
        expect(report.o.victory).toBe false

    describe 'too few pins to determine anything', ->
      it 'returns nothing', ->
        board.setPin('x', 0)
        board.setPin('o', 8)

        report = board.analyzeBoard()
        expect(report.x.victory).toBe false
        expect(report.o.victory).toBe false

    describe 'x has a diagonal chance', ->
      it 'returns player and opportunity', ->
        board.setPin('x', 0)
        board.setPin('x', 8)

        report = board.analyzeBoard()
        expect(report.x.opportunities).toContain 4

    describe 'diagonal chance already blocked', ->
      it 'returns nothing', ->
        board.setPin('x', 0)
        board.setPin('o', 4)
        board.setPin('x', 8)

        report = board.analyzeBoard()
        expect(report.x.opportunities).toEqual []


    describe 'x wins horizontally', ->
      it 'returns a winner and combo', ->
        board.setPin('x', 3)
        board.setPin('x', 4)
        board.setPin('x', 5)

        report = board.analyzeBoard()
        expect(report.x.victory).toBe true
        expect(report.x.pins).toEqual [3,4,5]

    describe 'o wins vertically', ->
      it 'returns a winner and combo', ->
        board.setPin('o', 1)
        board.setPin('o', 4)
        board.setPin('o', 7)

        report = board.analyzeBoard()
        expect(report.o.victory).toBe true
        expect(report.o.pins).toEqual [1,4,7]

  describe '#winner', ->
    it 'returns winner', ->
      spyOn(board, 'analyzeBoard').andReturn
        x:
          victory: true
        o:
          victory: false
      expect(board.winner()).toEqual 'x'
    it 'returns false if no winner', ->
      spyOn(board, 'analyzeBoard').andReturn
        x:
          victory: false
        o:
          victory: false
      expect(board.winner()).toEqual false

  describe '#winningPins', ->
    it 'returns winning pin indexes', ->
      spyOn(board, 'analyzeBoard').andReturn
        x:
          victory: true
          pins: [1,2,3]
        o:
          victory: false
      expect(board.winningPins()).toEqual [1,2,3]

  describe '#nextMove(player)', ->
    describe 'player has a chance to win', ->
      it 'returns winning pin index', ->
        spyOn(board, 'analyzeBoard').andReturn
          x:
            victory: false
            opportunities: [1,2]
          o:
            victory: false
            opportunities: []
        spyOn(board, 'choice').andReturn(1)

        expect(board.nextMove('x')).toEqual 1
        expect(board.choice).toHaveBeenCalledWith([1,2])

    describe 'player has a chance to block', ->
      it 'returns blocking pin index', ->
        spyOn(board, 'analyzeBoard').andReturn
          x:
            victory: false
            opportunities: []
          o:
            victory: false
            opportunities: [2]
        expect(board.nextMove('x')).toEqual 2

    describe 'player has both a chance to win and block', ->
      it 'returns winning pin index', ->
        spyOn(board, 'analyzeBoard').andReturn
          x:
            victory: false
            opportunities: [1]
          o:
            victory: false
            opportunities: [2]
        expect(board.nextMove('x')).toEqual 1
        expect(board.nextMove('o')).toEqual 2

    describe 'player has no opportunities', ->
      it 'returns random available pin index', ->
        spyOn(board, 'emptyFields').andReturn [0,1,2]
        spyOn(board, 'choice').andReturn 0

        expect(board.nextMove('x')).toEqual 0
        expect(board.choice).toHaveBeenCalledWith([0,1,2])

