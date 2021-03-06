Listing = require 'models/listing'

class Listings extends Backbone.Collection
  url: '/listings'
  model: Listing

  updateListTime: (seconds) =>
    modelsToRemove = []
    for model in @models
      model.incrementTimeInList(seconds)
      if model.get('time_in_list') > 60 * 1000
        modelsToRemove.push model

    for model in modelsToRemove
      @remove model

module.exports = Listings
