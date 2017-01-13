class Railsbackbone.Views.TasksIndex extends Backbone.View
  # Instead of generating a new element, bind to the existing skeleton of
  # the App already present in the HTML.
  el: '.todoapp'

  # Our template for the line of statistics at the bottom of the app.
  statsTemplate: _.template(
    "<span class='todo-count'>
      <strong><%= remaining %></strong>
      <%= remaining === 1 ? 'item' : 'items' %> left
    </span>
      <ul class='filters'>
        <li>
            <a class='selected' href='#/'>All</a>
        </li>
        <li>
            <a href='#/active'>Active</a>
        </li>
        <li>
            <a href='#/completed'>Completed</a>
        </li>
      </ul>
      <% if (completed) { %>
        <button class='clear-completed'>Clear completed</button>
      <% } %>"
    )

  # Delegated events for creating new items, and clearing completed ones.
  events: {
    'keypress .new-todo': 'createOnEnter',
    'click .clear-completed': 'clearCompleted',
    'click .toggle-all': 'toggleAllComplete'
  }


  # At initialization we bind to the relevant events on the `Todos`
  # collection, when items are added or changed. Kick things off by
  # loading any preexisting todos that might be saved in *localStorage*.
  initialize: ->
    console.log(@collection)
    this.allCheckbox = this.$('.toggle-all')[0]
    this.$input = this.$('.new-todo')
    this.$footer = this.$('.footer')
    this.$main = this.$('.main')
    this.$list = $('.todo-list')

    @collection.trigger('filter')

    this.listenTo(@collection, 'add', this.addOne)
    this.listenTo(@collection, 'reset', this.addAll)
    # this.listenTo(@collection, 'reset', this.render)
    this.listenTo(@collection, 'change:completed', this.filterOne)
    this.listenTo(@collection, 'filter', this.filterAll)
    this.listenTo(@collection, 'all', _.debounce(this.render, 0))

    # Suppresses 'add' events with {reset: true} and prevents the app view
    # from being re-rendered for every model. Only renders when the 'reset'
    # event is triggered at the end of the fetch.
    # @collection.fetch({reset: true})


  # Re-rendering the App just means refreshing the statistics -- the rest
  # of the app doesn't change.
  render: ->
    completed = @collection.completed().length
    remaining = @collection.remaining().length

    if @collection.length
      this.$main.show()
      this.$footer.show()

      this.$footer.html(this.statsTemplate({
        completed: completed,
        remaining: remaining
      }))

      this.$('.filters li a')
          .removeClass('selected')
          .filter('[href="#/' + (Railsbackbone.TaskFilter || '') + '"]')
          .addClass('selected')
    else
      this.$main.hide()
      this.$footer.hide()

      this.allCheckbox.checked = !remaining


  # Add a single todo item to the list by creating a view for it, and
  # appending its element to the `<ul>`.
  addOne: (todo) ->
    view = new Railsbackbone.Views.TasksItem({ model: todo })
    this.$list.append(view.render().el)


  # Add all items in the **Todos** collection at once.
  addAll: ->
    this.$list.html('')
    @collection.each(this.addOne, this)


  filterOne: (todo) ->
    todo.trigger('visible')


  filterAll: ->
    @collection.each(this.filterOne, this)


  # Generate the attributes for a new Todo item.
  newAttributes: ->
    return {
      title: this.$input.val().trim(),
      order: @collection.nextOrder(),
      completed: false
    }


  # If you hit return in the main input field, create new **Todo** model,
  # persisting it to *localStorage*.
  createOnEnter: (e) ->
    if e.which == ENTER_KEY && this.$input.val().trim()
      @collection.create(this.newAttributes())
      this.$input.val('')


  # Clear all completed todo items, destroying their models.
  clearCompleted: ->
    _.invoke(@collection.completed(), 'destroy')
    return false


  toggleAllComplete: ->
    completed = this.allCheckbox.checked
    _.each @collection.models, (task) ->
      task.save({completed: completed})
