class Tictactoe.Views.Stats extends Backbone.View
  template: HandlebarsTemplates['stats/stats']

  initialize: ->
    @stats = new Tictactoe.Models.Stats
    @stats.bind 'change', @render, this
    @stats.fetch()

  render: ->
    @$el.html @template(@stats.toJSON())

  refresh: ->
    @stats.fetch()



