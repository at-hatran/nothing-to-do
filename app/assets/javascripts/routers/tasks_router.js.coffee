class Railsbackbone.Routers.Tasks extends Backbone.Router
  routes:
    '': 'index'
    '*filter': 'setFilter'

  initialize: ->
    @tasks = new Railsbackbone.Collections.Tasks()
    @tasks.fetch({reset: true})

  index: ->
    Railsbackbone.TaskFilter = ''
    view = new Railsbackbone.Views.TasksIndex collection: @tasks
    # $('.todoapp').html(view.render().el)

  setFilter: (params) ->
    console.log('filtering...')
    Railsbackbone.TaskFilter = params || ''
    new Railsbackbone.Views.TasksIndex collection: @tasks
