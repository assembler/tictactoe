describe 'Tictactoe.Models.Game', ->
  game = null

  beforeEach ->
    game = new Tictactoe.Models.Game

  describe '#initialize', ->
    it 'instantiates new Board object', ->
      expect(game.board).toBeDefined()

  describe '#start', ->
    it 'picks random player', ->
      spyOn(game.board, 'randomPlayer').andReturn 'x'
      game.start()
      expect(game.get('player')).toEqual 'x'

    it 'makes move if cpu is first player', ->
      spyOn(game.board, 'randomPlayer').andReturn 'o'
      spyOn(game, 'cpuSetPin')
      game.start()
      expect(game.cpuSetPin).toHaveBeenCalled()

    it 'doesn\'t make move if human is first player', ->
      spyOn(game.board, 'randomPlayer').andReturn 'x'
      spyOn(game, 'cpuSetPin')
      game.start()
      expect(game.cpuSetPin).not.toHaveBeenCalled()

  describe '#getCpuPlayer', ->
    it 'returns the opposite player', ->
      game.set 'player', 'x'
      expect(game.getCpuPlayer()).toEqual 'o'
      game.set 'player', 'o'
      expect(game.getCpuPlayer()).toEqual 'x'

  describe '#cpuSetPin', ->
    it 'sets the pin for the CPU player and triggers change event', ->
      game.set 'player', 'o'
      spyOn(game.board, 'setPin')
      spyOn(game, 'trigger')
      game.cpuSetPin()
      expect(game.board.setPin).toHaveBeenCalled()
      expect(game.trigger).toHaveBeenCalledWith 'change'

  describe '#setPin(index)', ->
    it 'returns false if game is already over', ->
      spyOn(game.board, 'isGameOver').andReturn true
      expect(game.setPin(0)).toBe false

    it 'returns false on invalid move', ->
      spyOn(game.board, 'setPin').andReturn false
      expect(game.setPin(0)).toBe false

    it 'makes the move', ->
      game.set 'player', 'x'
      spyOn(game.board, 'setPin')
      game.setPin(0)
      expect(game.board.setPin).toHaveBeenCalledWith 'x', 0

    it 'respons with cpu move right away', ->
      game.set 'player', 'x'
      spyOn(game, 'cpuSetPin')
      game.setPin(0)
      expect(game.cpuSetPin).toHaveBeenCalled()

    it 'checks the game status afterwards', ->
      game.set 'player', 'x'
      spyOn(game, 'checkStatus')
      game.setPin(0)
      expect(game.checkStatus).toHaveBeenCalled()

  describe '#checkStatus', ->
    describe 'game is over', ->
      beforeEach ->
        game.set 'player', 'x'
        spyOn(game, 'trigger')
        spyOn(game.board, 'isGameOver').andReturn true
        spyOn(game.board, 'winningPins').andReturn [1,2,3]

      describe 'draw', ->
        it 'triggers over event with empty payload', ->
          spyOn(game.board, 'winner').andReturn null
          game.checkStatus()
          expect(game.trigger).toHaveBeenCalledWith 'over', null
          expect(game.get('victory')).not.toBeDefined()

      describe 'victory', ->
        it 'triggers over event and sets the victory property', ->
          spyOn(game.board, 'winner').andReturn 'x'
          game.checkStatus()
          expect(game.trigger).toHaveBeenCalledWith 'over', [1,2,3]
          expect(game.get('victory')).toBe true

      describe 'defeat', ->
        it 'triggers over event and sets the victory property', ->
          spyOn(game.board, 'winner').andReturn 'o'
          game.checkStatus()
          expect(game.trigger).toHaveBeenCalledWith 'over', [1,2,3]
          expect(game.get('victory')).toBe false

    describe 'game is not over yet', ->
      it 'doesn\'t trigger the "over" event', ->
        spyOn(game.board, 'isGameOver').andReturn false
        spyOn(game, 'trigger')
        game.checkStatus()
        expect(game.trigger).not.toHaveBeenCalled()

