window.app ?= {}

class app.ListingView extends Backbone.View
  tagName: "tr"

  initialize: ->
    @template = _.template $("#listing_row").html()
    @model.on 'change:time_in_list', @changeTimeInList
    @model.on 'change', @render

  render: =>
    $(@el).html @template(@model.toJSON())
    this

  changeTimeInList: (model, value) =>
    @$(".time").text(value + " min")

  remove: =>
    $(@el).remove()
