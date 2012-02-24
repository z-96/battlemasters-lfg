_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

class Clock
  constructor: (@serverTime) ->
    @jsTime = new Date().getTime() / 1000
    @secondsAhead = @jsTime - @serverTime

  getServerTime: (@clientTime) =>
    new Date(@clientTime.getTime() - @secondsAhead)

class EventBus
  constructor: ->
    @events = {}
    _.extend(@events, Backbone.Events)

  on: (args...) =>
    @events.on args...

  off: (args...) =>
    @events.off args...

  trigger: (args...) =>
    @events.trigger args...

class Application
  constructor: ->
    @bus        = new EventBus
    @clock      = new Clock(window.rubyTime)

    @mainRouter = new app.MainRouter(app: this)
    @listings   = new app.Listings
    @mainView   = new app.MainView(app: this, collection: @listings)
    @firstView = false

  start: =>
    @listings.reset window.preloadListings
    Backbone.history.start(silent: false)
    setInterval @updateListings, 10 * 1000
    setInterval @updateListTime, 10 * 1000

  updateListings: =>
    listings = new app.Listings
    listings.fetch
      success: @processListings

  processListings: (listings, response) =>
    existing_ids = _.map @listings.models, (model) ->
      model.get('id')
    new_ids      = _.map listings.models, (model) ->
      model.get('id')
    to_delete = []
    for model in @listings.models
      do (model) =>
        unless _.include new_ids, model.get('id')
          to_delete.push model.get('id')
    for id in to_delete
      @listings.remove @listings.get(id)
    for model in listings.models
      do (model) =>
        unless _.include existing_ids, model.get('id')
          @listings.add model

  updateListTime: =>
    @listings.updateListTime()

jQuery ->
  window.application = new Application
  window.application.start()
