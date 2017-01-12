class Railsbackbone.Routers.Tasks extends Backbone.Router
  routes:
    '': 'index'
    '*filter': 'setFilter'

  initialize: ->
    @tasks = new Railsbackbone.Collections.Tasks()
    # @tasks.fetch({reset: true})

  index: ->
    new Railsbackbone.Views.TasksIndex collection: @tasks

  setFilter: (params) ->
    console.log('filtering...')
    Railsbackbone.TaskFilter = params || ''
    @tasks.trigger('filter')
