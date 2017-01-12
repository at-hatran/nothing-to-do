class Railsbackbone.Models.Task extends Backbone.Model
  default: {
    title: '',
    completed: false
  }

  toggle: ->
    this.save({
      completed: !this.get('completed')
    })
