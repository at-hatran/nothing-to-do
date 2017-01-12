class Railsbackbone.Collections.Tasks extends Backbone.Collection
  url: '/tasks'
  model: Railsbackbone.Models.Task

  completed: ->
    this.where({completed: true})

  remaining: ->
    this.where({completed: false})

  nextOrder: ->
    this.length ? this.last().get('order') + 1 : 1

  comparator: 'order'
