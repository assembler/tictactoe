window.Tictactoe =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new Tictactoe.Views.Game

jQuery ($) ->
  Tictactoe.init()
